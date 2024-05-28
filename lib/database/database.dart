import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'package:aqua/database/tables.dart';
part 'database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'aqua.sqlite'));
    
    //if (!await file.exists()) {
        // Extract the pre-populated database file from assets
    final blob = await rootBundle.load('assets/aqua.db');
    final buffer = blob.buffer;
    await file.writeAsBytes(buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes));
    //}

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

  Future<List<Activity>> getActivities() async {
    return await select(activities).get();
  }

  Future<Activity> getActivity(int id) async {
    return await (select(activities)..where((tbl) => tbl.activityID.equals(id))).getSingle();
  }

  Future<List<Beverage>> getBeverages() async {
    return await select(beverages).get();
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    //beforeOpen: (details) async => await customStatement("PRAGMA foreign_keys = ON"),
    onCreate: (Migrator m) async {
      await m.createAll();
      print("Database created...");
      
      await into(beverages).insert(const Beverage(bevID: 1, bevName: "Water", colorCode: "FF44A4EE", waterPercent: 100));
      await into(beverages).insert(const Beverage(bevID: 2, bevName: "Soda", colorCode: "FFCC2936", waterPercent: 90));
      await into(beverages).insert(const Beverage(bevID: 3, bevName: "Coffee", colorCode: "FFFB8B24", waterPercent: 50));
      await into(beverages).insert(const Beverage(bevID: 4, bevName: "Tea", colorCode: "FF9BC53D", waterPercent: 75));
      await into(beverages).insert(const Beverage(bevID: 5, bevName: "Milk", colorCode: "FFFFD6DE", waterPercent: 88));
      
    },

    onUpgrade: (Migrator m, int from, int to) async {
      if (from == 1 && to == 2) {
        // Add new columns, tables, or other schema changes
      }
    },
      );
}

