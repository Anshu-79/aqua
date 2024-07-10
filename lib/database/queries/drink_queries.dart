import 'package:drift/drift.dart';
import 'package:flutter/material.dart' show DateUtils;

import 'package:aqua/database/database.dart';
import 'package:aqua/utils/miscellaneous.dart';
import 'package:aqua/utils/shared_pref_utils.dart';

extension DrinkQueries on Database {
  Future<int> insertOrUpdateDrink(DrinksCompanion entity) async {
    return await into(drinks).insert(entity);
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
}
