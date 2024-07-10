import 'package:drift/drift.dart';

import 'package:aqua/database/database.dart';

extension BeverageQueries on Database {
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
}
