import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart' show DateUtils;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'package:aqua/shared_pref_utils.dart';
import 'package:aqua/utils/colors.dart';
import 'package:aqua/water_goals.dart';
import 'package:aqua/database/tables.dart';
import 'package:aqua/utils.dart';
part 'database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'aqua.sqlite'));

    if (!await file.exists()) {
      // Extract the pre-populated database file from assets
      final blob = await rootBundle.load('assets/aqua.db');
      final buffer = blob.buffer;
      await file.writeAsBytes(
          buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes));
    }

    // Also work around limitations on old Android versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [Beverages, Drinks, Activities, Workouts, WaterGoals])
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> getUserVersion() async {
    final result = await customSelect('PRAGMA user_version;').getSingle();
    return result.data['user_version'] as int;
  }

  // Activities Actions
  Future<List<Activity>> getActivities() async {
    return await select(activities).get();
  }

  Future<Activity> getActivity(int id) async {
    return await (select(activities)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  // Beverages Actions

  Future<List<Beverage>> getBeverages() async => await select(beverages).get();

  Future<Beverage> getBeverage(int id) async {
    return await (select(beverages)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  Future<int> toggleBeverageStar(int id, bool starred) async {
    return (update(beverages)..where((t) => t.id.equals(id)))
        .write(BeveragesCompanion(starred: Value(!starred)));
  }

  Future<List<Beverage>> getStarredBeverages() async {
    return (select(beverages)..where((t) => t.starred.equals(true))).get();
  }

  Future<Beverage> getBeverageFromName(String name) async {
    final query = select(beverages)..where((t) => t.name.equals(name));
    final bevs = await query.get();
    if (bevs.isEmpty) return getBeverageFromName('Water');
    return bevs[0];
  }

  Future<int> insertOrUpdateBeverage(BeveragesCompanion entity) async {
    return await into(beverages).insertOnConflictUpdate(entity);
  }

  Future<int> deleteBeverage(int id) async {
    // delete all drinks associated with beverage
    await (delete(drinks)..where((tbl) => tbl.bevID.equals(id))).go();
    return await (delete(beverages)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Workouts Actions
  Future<List<Workout>> getTodaysWorkouts() async {
    DateTime now = DateTime.now();
    now = await shiftToWakeTime(now);
    final int wakeHour = await SharedPrefUtils.getWakeTime();
    final todayStart = DateTime(now.year, now.month, now.day, wakeHour);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final query = select(workouts)
      ..where((tbl) => tbl.datetime.isBetweenValues(todayStart, todayEnd));

    return query.get();
  }

  Future<List<Workout>> getAllWorkouts() async => await select(workouts).get();

  Future<Map<Activity, int>> totalDurationPerActivity() async {
    final query = selectOnly(workouts)
      ..addColumns([workouts.activityID, workouts.duration.sum()]);
    query.groupBy([workouts.activityID]);

    final result = await query.get();

    final activityIDs =
        result.map((row) => row.read(workouts.activityID)).toList();

    final Map<Activity, int> aggregatedData = {};
    for (final id in activityIDs) {
      final totalDuration = result
          .where((row) => row.read(workouts.activityID) == id)
          .map<int>((row) => row.read(workouts.duration.sum()) as int)
          .reduce((value, element) => value + element);

      final activity = await (select(activities)
            ..where((tbl) => tbl.id.equals(id!)))
          .getSingle();

      aggregatedData[activity] = totalDuration;
    }
    return aggregatedData;
  }

  Future<int> insertOrUpdateWorkout(WorkoutsCompanion entity) async {
    return await into(workouts).insertOnConflictUpdate(entity);
  }

  // Drinks Actions
  Future<int> insertOrUpdateDrink(DrinksCompanion entity) async {
    return await into(drinks).insert(entity);
  }

  Future<Map<Beverage, int>> totalVolumePerBeverage() async {
    final query = selectOnly(drinks)
      ..addColumns([drinks.bevID, drinks.volume.sum()]);
    query.groupBy([drinks.bevID]);

    final result = await query.get();

    final bevIDs = result.map((row) => row.read(drinks.bevID)).toList();

    final Map<Beverage, int> aggregatedData = {};
    for (final id in bevIDs) {
      final totalVolume = result
          .where((row) => row.read(drinks.bevID) == id)
          .map<int>((row) => row.read(drinks.volume.sum()) as int)
          .reduce((value, element) => value + element);

      final beverage = await (select(beverages)
            ..where((tbl) => tbl.id.equals(id!)))
          .getSingle();

      aggregatedData[beverage] = totalVolume;
    }
    return aggregatedData;
  }

  Future<Map<DateTime, int>> getDailyConsumption(int bevID, int range) async {
    DateTime endDate = await shiftToWakeTime(DateTime.now());
    endDate = DateUtils.dateOnly(endDate);
    DateTime startDate = endDate.subtract(Duration(days: range));

    final query = selectOnly(drinks)
      ..addColumns([drinks.datetime.date, drinks.volume.sum()])
      ..where(drinks.bevID.equals(bevID))
      ..groupBy([drinks.datetime.date]);

    final result = await query.get();

    final Map<DateTime, int> aggregatedData = {};

    for (DateTime date = startDate;
        date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
        date = date.add(const Duration(days: 1))) {
      aggregatedData[date] = 0;
    }

    for (final row in result) {
      final date = DateTime.parse(row.read(drinks.datetime.date)!);
      final totalVolume = row.read(drinks.volume.sum()) as int;
      aggregatedData[date] = totalVolume;
    }
    return aggregatedData;
  }

  Future<Map<Beverage, Map>> bevWiseDailyConsumption(int range) async {
    final beverages = await getBeverages();

    Map<Beverage, Map> aggregatedData = {};
    for (final bev in beverages) {
      final bevsConsumptionList = await getDailyConsumption(bev.id, range);
      aggregatedData[bev] = bevsConsumptionList;
    }
    return aggregatedData;
  }

  Future<Map<Beverage, int>> getBevConsumption(String date) async {
    final query = selectOnly(drinks)
      ..addColumns([drinks.bevID, drinks.volume.sum()])
      ..where(drinks.datetime.date.equals(date))
      ..groupBy([drinks.bevID]);

    final result = await query.get();

    final Map<Beverage, int> aggregatedData = {};

    for (final row in result) {
      final id = row.read(drinks.bevID)!;
      final totalVolume = row.read(drinks.volume.sum()) as int;
      Beverage beverage = await getBeverage(id);
      aggregatedData[beverage] = totalVolume;
    }

    return aggregatedData;
  }

  Future<Map<String, Map<Beverage, int>>> daywiseAllBevsConsumption() async {
    final query = selectOnly(drinks, distinct: true)
      ..addColumns([drinks.datetime.date]);
    final result = await query.get();

    final List<String> dates =
        result.map((row) => row.read(drinks.datetime.date)!).toList();

    Map<String, Map<Beverage, int>> aggregatedData = {};
    for (final date in dates) {
      final bevsConsumptionList = await getBevConsumption(date);
      aggregatedData[date] = bevsConsumptionList;
    }
    return aggregatedData;
  }

  Future<int> insertWater(int volume) async {
    DrinksCompanion water = DrinksCompanion(
        bevID: const Value(1),
        volume: Value(volume),
        datetime: Value(DateTime.now()),
        datetimeOffset: Value(await SharedPrefUtils.getWakeTime()));
    return await into(drinks).insert(water);
  }

  Future<List<Drink>> getDrinks() async => await select(drinks).get();

  Future<List<Drink>> getWaterDrinks() async {
    final query = select(drinks)..where((tbl) => tbl.bevID.equals(1));
    return await query.get();
  }

  Future<List<Drink>> getDrinksOfDay(DateTime date) async {
    final startOfDay =
        await shiftToWakeTime(DateTime(date.year, date.month, date.day));
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    return (select(drinks)
          ..where((d) =>
              d.datetime.isBiggerOrEqualValue(startOfDay) &
              d.datetime.isSmallerOrEqualValue(endOfDay)))
        .get();
  }

  Future<int> getDrinkCount() async {
    return customSelect('SELECT COUNT(*) FROM drinks', readsFrom: {drinks})
        .map((row) => row.read<int>('COUNT(*)'))
        .getSingle();
  }

  Future<List<Drink>?> getLastNDrinks(int n) async {
    if (await getDrinkCount() == 0) return null;

    return (select(drinks)
          ..orderBy([
            (t) => OrderingTerm(mode: OrderingMode.desc, expression: t.datetime)
          ])
          ..limit(n))
        .get();
  }

  Future<int> calcMedianDrinkSize() async {
    int sampleSize = 20; // Number of recent drinks to calculate median

    List<Drink>? drinks = await getLastNDrinks(sampleSize);

    if (drinks == null) return 200;

    List<int> drinkSizes =
        List.generate(drinks.length, (i) => drinks[i].volume);
    drinkSizes.sort();

    return drinkSizes[drinkSizes.length ~/ 2]; // Median is at middle position
  }

  // The input variables consumed & total are nullable since they
  // don't need to be passed everytime. Currently, they are passed only when 
  // the function is called from setTodaysGoal()
  Future<int> calcReminderGap(int? consumed, int? total) async {
    DateTime now = DateTime.now();

    WaterGoal? todaysGoal = await getGoal(now);

    consumed ??= todaysGoal!.consumedVolume;
    total ??= todaysGoal!.totalVolume;

    final int toDrink = total - consumed;

    // If day's goal has been completed, next reminder will
    // be at the waking time of next day
    if (toDrink <= 0) {
      final wakeHour = await SharedPrefUtils.getWakeTime();
      DateTime wakeTime = DateTime(now.year, now.month, now.day, wakeHour);

      if (wakeTime.isBefore(now)) {
        wakeTime = wakeTime.add(const Duration(days: 1));
      }
      return wakeTime.difference(now).inMinutes;
    }

    final int drinkSize = await calcMedianDrinkSize();
    int drinksNeeded = toDrink ~/ drinkSize;

    // Assume a minimum of 1 drink
    if (drinksNeeded == 0) drinksNeeded = 1;

    final int sleepHour = await SharedPrefUtils.getSleepTime();
    DateTime sleepTime = DateTime(now.year, now.month, now.day, sleepHour);

    if (sleepTime.isBefore(now)) {
      sleepTime = sleepTime.add(const Duration(days: 1));
    }

    Duration timeLeft = sleepTime.difference(now);

    double reminderGap = timeLeft.inMinutes / drinksNeeded;

    if (reminderGap < 10) return 10; // Throttle minumum Reminder gap at 10 min
    return reminderGap.round();
  }

  Future<int> getStoredReminderGap() async {
    WaterGoal? todaysGoal = await getGoal(DateTime.now());
    return todaysGoal!.reminderGap;
  }

  // Water Goals Actions

  Future<List<WaterGoal>> getWaterGoals() async =>
      await select(waterGoals).get();

  Future<WaterGoal?> getGoal(DateTime datetime) async {
    final DateTime dateOnly = await convertToWaterGoalID(datetime);

    return await (select(waterGoals)..where((tbl) => tbl.date.equals(dateOnly)))
        .getSingleOrNull();
  }

  Future<WaterGoal> setTodaysGoal() async {
    DateTime dateOnly = await convertToWaterGoalID(DateTime.now());

    WaterGoal? existingGoal = await getGoal(DateTime.now());
    print(existingGoal);

    if (existingGoal != null) return existingGoal;

    final int totalIntake = await calcTodaysGoal();
    int consumed = 0;
    int gap = await calcReminderGap(consumed, totalIntake);

    final goal = WaterGoalsCompanion(
        date: Value(dateOnly),
        totalVolume: Value(totalIntake),
        consumedVolume: Value(consumed),
        reminderGap: Value(gap),
        datetimeOffset: Value(await SharedPrefUtils.getWakeTime()));

    return await into(waterGoals).insertReturning(goal);
  }

  Future<int> updateConsumedVolume(int consumedVolIncrease) async {
    final goal = await getGoal(DateTime.now());
    int gap = await calcReminderGap(null, null);

    return (update(waterGoals)..where((t) => t.date.equals(goal!.date))).write(
        WaterGoalsCompanion(
            consumedVolume: Value(goal!.consumedVolume + consumedVolIncrease),
            reminderGap: Value(gap)));
  }

  Future<int> updateTotalVolume(int totalVolIncrease) async {
    final goal = await getGoal(DateTime.now());
    int newTotalVol = totalVolIncrease + goal!.totalVolume;
    int gap = await calcReminderGap(null, null);

    return (update(waterGoals)..where((t) => t.date.equals(goal.date))).write(
        WaterGoalsCompanion(
            totalVolume: Value(newTotalVol), reminderGap: Value(gap)));
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          List<BeveragesCompanion> defaultBeverages = [
            BeveragesCompanion(
              name: const Value("Water"),
              colorCode: Value(AquaColors.blue.value.toRadixString(16)),
              waterPercent: const Value(100),
              starred: const Value(true),
            ),
            BeveragesCompanion(
              name: const Value("Soda"),
              colorCode: Value(AquaColors.red.value.toRadixString(16)),
              waterPercent: const Value(90),
              starred: const Value(true),
            ),
            BeveragesCompanion(
              name: const Value("Coffee"),
              colorCode:
                  Value(AquaColors.orange.value.toRadixString(16)),
              waterPercent: const Value(50),
              starred: const Value(false),
            ),
            BeveragesCompanion(
              name: const Value("Tea"),
              colorCode: Value(AquaColors.green.value.toRadixString(16)),
              waterPercent: const Value(75),
              starred: const Value(false),
            ),
            BeveragesCompanion(
              name: const Value("Milk"),
              colorCode: Value(AquaColors.pink.value.toRadixString(16)),
              waterPercent: const Value(88),
              starred: const Value(false),
            ),
          ];

          await m.createAll();
          print("Database created...");
          for (final beverage in defaultBeverages) {
            await into(beverages).insert(beverage);
          }
        },
        beforeOpen: (details) async {
          print("beforeOpen executed...");
          await customStatement("PRAGMA foreign_keys = ON");
        },
        onUpgrade: (m, from, to) async {
          print("onUpgrade executed");
          await customStatement('PRAGMA foreign_keys = OFF');
        },
      );
}
