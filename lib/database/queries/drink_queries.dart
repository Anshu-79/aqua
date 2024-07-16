import 'package:drift/drift.dart';
import 'package:flutter/material.dart' show DateUtils;

import 'package:aqua/database/database.dart';
import 'package:aqua/utils/miscellaneous.dart';
import 'package:aqua/utils/shared_pref_utils.dart';

/// Extension on the `Database` class to provide drinks-related queries.
extension DrinkQueries on Database {
  /// Fetches all items in [drinks] for the day & the associated [Beverage]
  /// in the form of a map between a [Drink] and an [Beverage]
  /// Note that the current datetime is first shifted to wakeTime
  Future<Map<Drink, Beverage>> getTodaysDrinks() async {
    DateTime now = DateTime.now();
    now = await shiftToWakeTime(now);
    final int wakeHour = await SharedPrefUtils.getWakeTime();
    final todayStart = DateTime(now.year, now.month, now.day, wakeHour);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final query = select(drinks).join(
      [innerJoin(beverages, beverages.id.equalsExp(drinks.bevID))],
    )..where(drinks.datetime.isBetweenValues(todayStart, todayEnd));

    final result = await query.get();
    final Map<Drink, Beverage> drinkBeverageMap = {};

    for (final row in result) {
      final drink = row.readTable(drinks);
      final beverage = row.readTable(beverages);
      drinkBeverageMap[drink] = beverage;
    }

    return drinkBeverageMap;
  }

  /// Tries to insert an item into [drinks]
  /// If failed due to conflict, it updates said [Drink]
  Future<int> insertOrUpdateDrink(DrinksCompanion entity) async {
    return await into(drinks).insert(entity);
  }

  /// Returns a map of a date with the volume of [Beverage] with [bevID] drank on the day
  ///
  /// For eg:
  /// ```dart
  /// Map resultMap = await getDailyConsumption(1, 7);
  /// ```
  /// Then, resultMap will be:
  /// ```dart
  /// { "Water": {01-01-1970 00:00:00.000: 10, 02-01-1970 00:00:00.000: 20, ...}
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

  /// Deletes a [Drink] containing [id]
  Future<int> deleteDrink(int id) async {
    return await (delete(drinks)..where((tbl) => tbl.id.equals(id))).go();
  }


  /// Adds an item to [drinks] with [bevID] = 1 (ie Water)
  Future<int> insertWater(int volume) async {
    DrinksCompanion water = DrinksCompanion(
        bevID: const Value(1),
        volume: Value(volume),
        datetime: Value(DateTime.now()),
        datetimeOffset: Value(await SharedPrefUtils.getWakeTime()));
    return await into(drinks).insert(water);
  }

  Future<List<Drink>> getDrinks() async => await select(drinks).get();

  /// Only fetches the items in [drinks] which are water (ie bevID = 1)
  Future<List<Drink>> getWaterDrinks() async {
    final query = select(drinks)..where((tbl) => tbl.bevID.equals(1));
    return await query.get();
  }

  /// Fetches the number of items in [drinks]
  Future<int> getDrinkCount() async {
    return customSelect('SELECT COUNT(*) FROM drinks', readsFrom: {drinks})
        .map((row) => row.read<int>('COUNT(*)'))
        .getSingle();
  }

  /// Fetches the last [n] items from [drinks]
  Future<List<Drink>?> getLastNDrinks(int n) async {
    if (await getDrinkCount() == 0) return null;

    return (select(drinks)
          ..orderBy([
            (t) => OrderingTerm(mode: OrderingMode.desc, expression: t.datetime)
          ])
          ..limit(n))
        .get();
  }
}
