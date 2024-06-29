import 'dart:io';
import 'package:aqua/shared_pref_utils.dart';
import 'package:aqua/water_goals.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

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
    return await (delete(beverages)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Workouts Actions
  Future<List<Workout>> getTodaysWorkouts() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    final query = select(workouts)
      ..where((tbl) => tbl.datetime.isBetweenValues(todayStart, todayEnd));

    return query.get();
  }

  Future<int> insertOrUpdateWorkout(WorkoutsCompanion entity) async {
    return await into(workouts).insertOnConflictUpdate(entity);
  }

  // Drinks Actions
  Future<int> insertOrUpdateDrink(DrinksCompanion entity) async {
    return await into(drinks).insertOnConflictUpdate(entity);
  }

  Future<List<Drink>> getDrinks() async => await select(drinks).get();

  Future<List<Drink>> getDrinksOfDay(DateTime date) async {
    final startOfDay = await shiftToWakeTime(DateTime(date.year, date.month, date.day));
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

  Future<int> calcReminderGap(int consumed, int total) async {
    final int toDrink = total - consumed;
    final int drinkSize = await calcMedianDrinkSize();
    int drinksNeeded = toDrink ~/ drinkSize;

    DateTime now = DateTime.now();

    final int? sleepHour = await SharedPrefUtils.readInt('sleepTime');
    DateTime sleepTime = DateTime(now.year, now.month, now.day, sleepHour!);

    if (sleepTime.isBefore(now)) {
      sleepTime = sleepTime.add(const Duration(days: 1));
    }

    Duration timeLeft = sleepTime.difference(now);

    double reminderGap = timeLeft.inMinutes / drinksNeeded;

    if (reminderGap < 10) return 10; // Throttle minumum Reminder gap at 10 min
    return reminderGap.round();
  }

  Future<int> minutesElapsedSinceLastDrink() async {
    List<Drink> drinks = await getDrinks();
    if (drinks.isEmpty) return 0;
    // If no drinks have been logged, no time has passed since last drink

    Drink lastDrink = drinks.last;
    Duration timeElapsed = DateTime.now().difference(lastDrink.datetime);

    return timeElapsed.inMinutes;
  }

  // Time in next reminder is the difference of reminder gap specified & the time elapsed
  Future<int> minutesInNextReminder() async {
    int minutesPassed = await minutesElapsedSinceLastDrink();

    WaterGoal? todaysGoal = await getGoal(DateTime.now());

    return todaysGoal!.reminderGap - minutesPassed;
  }

  // Water Goals Actions
  Future<WaterGoal?> getGoal(DateTime datetime) async {
    final DateTime dateOnly = await convertToWaterGoalID(datetime);

    return await (select(waterGoals)..where((tbl) => tbl.date.equals(dateOnly)))
        .getSingleOrNull();
  }

  Future<void> setTodaysGoal() async {
    DateTime dateOnly = await convertToWaterGoalID(DateTime.now());

    WaterGoal? existingGoal = await getGoal(DateTime.now());
    print(existingGoal);

    if (existingGoal != null) return;

    final int totalIntake = await calcTodaysGoal();
    int consumed = 0;
    int gap = await calcReminderGap(consumed, totalIntake);

    final goal = WaterGoalsCompanion(
      date: Value(dateOnly),
      totalVolume: Value(totalIntake),
      consumedVolume: Value(consumed),
      reminderGap: Value(gap),
      datetimeOffset: Value(await SharedPrefUtils.getWakeTime())
    );

    print(goal);
    await into(waterGoals).insertOnConflictUpdate(goal);
  }

  Future<int> updateConsumedVolume(int consumedVol) async {
    final goal = await getGoal(DateTime.now());
    int newConsumedVol = consumedVol + goal!.consumedVolume;
    int gap = await calcReminderGap(newConsumedVol, goal.totalVolume);

    return (update(waterGoals)..where((t) => t.date.equals(goal.date))).write(
        WaterGoalsCompanion(
            consumedVolume: Value(goal.consumedVolume + consumedVol),
            reminderGap: Value(gap)));
  }

  Future<int> updateTotalVolume(int totalVolIncrease) async {
    final goal = await getGoal(DateTime.now());
    int newTotalVol = totalVolIncrease + goal!.totalVolume;
    int gap = await calcReminderGap(goal.consumedVolume, newTotalVol);

    return (update(waterGoals)..where((t) => t.date.equals(goal.date))).write(
        WaterGoalsCompanion(
            totalVolume: Value(newTotalVol), reminderGap: Value(gap)));
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          print("Database created...");
          await into(beverages).insertOnConflictUpdate(Beverage(
            id: 1,
            name: "Water",
            colorCode: defaultColors['blue']!.value.toRadixString(16),
            waterPercent: 100,
            starred: true,
          ));
          await into(beverages).insertOnConflictUpdate(Beverage(
            id: 2,
            name: "Soda",
            colorCode: defaultColors['red']!.value.toRadixString(16),
            waterPercent: 90,
            starred: true,
          ));
          await into(beverages).insertOnConflictUpdate(Beverage(
            id: 3,
            name: "Coffee",
            colorCode: defaultColors['orange']!.value.toRadixString(16),
            waterPercent: 50,
            starred: true,
          ));
          await into(beverages).insertOnConflictUpdate(Beverage(
            id: 4,
            name: "Tea",
            colorCode: defaultColors['green']!.value.toRadixString(16),
            waterPercent: 75,
            starred: true,
          ));
          await into(beverages).insertOnConflictUpdate(Beverage(
            id: 5,
            name: "Milk",
            colorCode: defaultColors['pink']!.value.toRadixString(16),
            waterPercent: 88,
            starred: false,
          ));
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
