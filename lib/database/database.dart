import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'package:aqua/utils/colors.dart';
import 'package:aqua/database/tables.dart';

export 'package:aqua/database/queries/activity_queries.dart';
export 'package:aqua/database/queries/beverage_queries.dart';
export 'package:aqua/database/queries/drink_queries.dart';
export 'package:aqua/database/queries/general_queries.dart';
export 'package:aqua/database/queries/water_goal_queries.dart';
export 'package:aqua/database/queries/workout_queries.dart';

part 'database.g.dart';

/// Defines the [Database] object used throughout the app
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Set the filepath to save the database file
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'aqua.sqlite'));

    // If file doesn't exist (ie app running for the first time), pre-populate it with
    // a db file containing the activities
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

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {

          /// A [List] of the default Beverages defined in Aqua
          /// Except Water, all of these can be edited by the user
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
              colorCode: Value(AquaColors.orange.value.toRadixString(16)),
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

          // Default beverages are inserted when the database is created
          await m.createAll();
          for (final beverage in defaultBeverages) {
            await into(beverages).insert(beverage);
          }
        },
        beforeOpen: (details) async {
          await customStatement("PRAGMA foreign_keys = ON");
        },
        onUpgrade: (m, from, to) async {
          await customStatement('PRAGMA foreign_keys = OFF');
        },
      );
}
