import 'package:drift/drift.dart';

class Beverages extends Table {
  IntColumn get bevID => integer().autoIncrement().named("bev_ID")();
  TextColumn get bevName => text()();
  TextColumn get colorCode => text().withLength(max: 8, min: 8)();
  IntColumn get waterPercent => integer()();
}

class Drinks extends Table {
  IntColumn get drinkID => integer().autoIncrement().named("drink_ID")();
  IntColumn get bevID => integer().references(Beverages, #bevID).named("bev_ID")();
  IntColumn get volume => integer()();
  DateTimeColumn get datetime => dateTime()();
}

class Activities extends Table {
  IntColumn get activityID => integer().autoIncrement().named("activity_ID")();
  TextColumn get category => text().withLength(max: 25)();
  RealColumn get met => real().named('MET')();
  TextColumn get description => text()();
}

class Workouts extends Table {
  IntColumn get workoutID => integer().autoIncrement().named("workout_ID")();
  IntColumn get activityID => integer().references(Activities, #activityID).named("activity_ID")();
  DateTimeColumn get datetime => dateTime()();
  IntColumn get duration => integer()();
}

class WaterGoals extends Table {
  DateTimeColumn get date => dateTime()();
  IntColumn get totalVolume => integer()();
  IntColumn get consumedVolume => integer()();
  IntColumn get reminderGap => integer()();

  @override
  Set<Column> get primaryKey => {date};
}
