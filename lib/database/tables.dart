import 'package:aqua/shared_pref_utils.dart';
import 'package:drift/drift.dart';

// The dateTimeOffset column stores the wakeTime when the entry was created.
// This ensures dates change at wakeTime instead of midnight.
// Helper functions for conversions are available in utility files.
Future<int> getWakeTime() async =>
    await SharedPrefUtils.readInt('wakeTime') ?? 0;

class Beverages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get colorCode => text().withLength(max: 8, min: 8)();
  IntColumn get waterPercent => integer()();
  BoolColumn get starred => boolean().withDefault(const Constant(false))();
}

class Drinks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get bevID => integer().references(Beverages, #id).named("bev_ID")();
  IntColumn get volume => integer()();
  DateTimeColumn get datetime => dateTime()();
  IntColumn get datetimeOffset => integer()();
}

class Activities extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => text().withLength(max: 25)();
  RealColumn get met => real().named('MET')();
  TextColumn get description => text()();
}

class Workouts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get activityID =>
      integer().references(Activities, #id).named("activity_ID")();
  DateTimeColumn get datetime => dateTime()();
  IntColumn get duration => integer()();
  IntColumn get waterLoss => integer()();
  IntColumn get datetimeOffset => integer()();
}

class WaterGoals extends Table {
  DateTimeColumn get date => dateTime()();
  IntColumn get totalVolume => integer()();
  IntColumn get consumedVolume => integer()();
  IntColumn get reminderGap => integer()();
  IntColumn get datetimeOffset => integer()();

  @override
  Set<Column> get primaryKey => {date};
}
