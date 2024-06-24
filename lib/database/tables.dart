import 'package:drift/drift.dart';

class Beverages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get colorCode => text().withLength(max: 8, min: 8)();
  IntColumn get waterPercent => integer()();
  BoolColumn get starred => boolean()();
}

class Drinks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get bevID => integer().references(Beverages, #id).named("bev_ID")();
  IntColumn get volume => integer()();
  DateTimeColumn get datetime => dateTime()();
}

class Activities extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => text().withLength(max: 25)();
  RealColumn get met => real().named('MET')();
  TextColumn get description => text()();
}

class Workouts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get activityID => integer().references(Activities, #id).named("activity_ID")();
  DateTimeColumn get datetime => dateTime()();
  IntColumn get duration => integer()();
}

class WaterGoals extends Table {
  DateTimeColumn get date => dateTime()();
  IntColumn get totalVolume => integer()();
  IntColumn get consumedVolume => integer()();

  @override
  Set<Column> get primaryKey => {date};
}
