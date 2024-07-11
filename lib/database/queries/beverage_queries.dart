import 'package:drift/drift.dart';

import 'package:aqua/database/database.dart';

/// Extension on the `Database` class to provide beverage-related queries.
extension BeverageQueries on Database {
  /// Fetches all items in [beverages]
  Future<List<Beverage>> getBeverages() async => await select(beverages).get();

  /// Fetches a single [Beverage] by [Beverage.id]
  Future<Beverage> getBeverage(int id) async =>
      await (select(beverages)..where((tbl) => tbl.id.equals(id))).getSingle();

  /// Inverts the [Beverage.starred] property which is a [bool]
  Future<int> toggleBeverageStar(int id, bool starred) async {
    return (update(beverages)..where((t) => t.id.equals(id)))
        .write(BeveragesCompanion(starred: Value(!starred)));
  }

  /// Fetches items where [Beverage.starred] is true
  Future<List<Beverage>> getStarredBeverages() async {
    return (select(beverages)..where((t) => t.starred.equals(true))).get();
  }

  /// Tries to insert an item into [beverages]
  /// If failed due to conflict, it updates said [Beverage]
  Future<int> insertOrUpdateBeverage(BeveragesCompanion entity) async {
    return await into(beverages).insertOnConflictUpdate(entity);
  }

  /// Deletes a [Beverage] along with any [Drink] containing [id] for [Drink.bevID]
  Future<int> deleteBeverage(int id) async {
    await (delete(drinks)..where((tbl) => tbl.bevID.equals(id))).go();

    return await (delete(beverages)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Fetches a mapping of each [Beverage] & the total volume of it consumed
  Future<Map<Beverage, int>> totalVolumePerBeverage() async {
    // Group all drinks based on beverageID
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

  /// Fetches a mapping of every [Beverage] mapped with another
  /// Map of a date and the amount of beverage drank on that date
  ///
  /// A sample output would be, for eg:
  /// ```dart
  /// { "Water": {01-01-1970 00:00:00.000: 10, 02-01-1970 00:00:00.000: 20},
  ///   "Coffee": {01-01-1970 00:00:00.000: 30, 02-01-1970 00:00:00.000: 40},
  /// }
  /// ```
  Future<Map<Beverage, Map>> bevWiseDailyConsumption(int range) async {
    final beverages = await getBeverages();

    Map<Beverage, Map> aggregatedData = {};
    for (final bev in beverages) {
      final bevsConsumptionList = await getDailyConsumption(bev.id, range);
      aggregatedData[bev] = bevsConsumptionList;
    }
    return aggregatedData;
  }

  /// Returns a mapping of every [Beverage] with the volume of it consumed on [date]
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

  /// Returns the mapping of a day mapped with a Map of [Beverage] and volume
  /// 
  /// A sample output would be, for eg:
  /// ```dart
  /// {01-01-1970: {WaterBeverage: 10, CoffeeBeverage: 30},
  ///  02-01-1970: {WaterBeverage: 20, CoffeeBeverage: 40},
  /// }
  /// ```
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
}
