import 'package:drift/drift.dart';

/// The [Beverages] table stores the variety of beverages inputted by the user
/// Its primary objective is to hold the [colorCode] & [waterPercent] for every [Drink]
class Beverages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get colorCode => text().withLength(max: 8, min: 8)();
  IntColumn get waterPercent => integer()();
  BoolColumn get starred => boolean().withDefault(const Constant(false))();
}

/// The [Drinks] table stores all the drinks taken by the user
/// It is linked with [Beverages] using [Beverages.id] 
class Drinks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get bevID => integer().references(Beverages, #id).named("bev_ID")();
  IntColumn get volume => integer()();
  DateTimeColumn get datetime => dateTime()();
  IntColumn get datetimeOffset => integer()();
}

/// The [Activities] table stores the variety of physical activities a user can perform
/// Its primary objective is to hold the [met] value & [category] of a workout
class Activities extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => text().withLength(max: 25)();
  RealColumn get met => real().named('MET')();
  TextColumn get description => text()();
}

/// The [Workouts] table stores all the workouts carried out by the user
/// It is linked with [Activities] using [Activities.id] 
class Workouts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get activityID =>
      integer().references(Activities, #id).named("activity_ID")();
  DateTimeColumn get datetime => dateTime()();
  IntColumn get duration => integer()();
  IntColumn get waterLoss => integer()();
  IntColumn get datetimeOffset => integer()();
}

/// The [WaterGoals] table stores the values related to intake goals of a day
/// The date is used as a primary key
class WaterGoals extends Table {
  DateTimeColumn get date => dateTime()();
  IntColumn get totalVolume => integer()();
  IntColumn get consumedVolume => integer()();
  IntColumn get reminderGap => integer()();
  IntColumn get datetimeOffset => integer()();

  @override
  Set<Column> get primaryKey => {date};
}
