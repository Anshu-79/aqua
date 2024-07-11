import 'package:drift/drift.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils/shared_pref_utils.dart';
import 'package:aqua/utils/miscellaneous.dart';
import 'package:aqua/intake_calculations.dart';

/// Extension on the `Database` class to provide waterGoal-related queries.
extension WaterGoalQueries on Database {
  /// Fetches the [WaterGoal] of all days
  Future<List<WaterGoal>> getWaterGoals() async =>
      await select(waterGoals).get();

  /// Fetches the [WaterGoal] of current day
  ///
  /// [convertToWaterGoalID] shifts [datetime] to [wakeTime] & then converts it to a date
  Future<WaterGoal?> getGoal(DateTime datetime) async {
    final DateTime dateOnly = await convertToWaterGoalID(datetime);

    return await (select(waterGoals)..where((tbl) => tbl.date.equals(dateOnly)))
        .getSingleOrNull();
  }

  /// Checks if a [WaterGoal] exists for current date
  /// If yes, returns that [WaterGoal]
  /// If no, calculates the water goal for that day, inserts it
  /// into the database and returns it
  Future<WaterGoal> setTodaysGoal() async {
    DateTime dateOnly = await convertToWaterGoalID(DateTime.now());

    WaterGoal? existingGoal = await getGoal(DateTime.now());

    if (existingGoal != null) return existingGoal;

    final int totalIntake = await calcTodaysGoal();
    int consumed = 0;
    int gap = await calcReminderGap(consumed, totalIntake);

    final goal = WaterGoalsCompanion(
        date: Value(dateOnly),
        totalVolume: Value(totalIntake),
        consumedVolume: Value(consumed),
        reminderGap: Value(gap),
        datetimeOffset: Value(await SharedPrefUtils.getWakeTime()));

    return await into(waterGoals).insertReturning(goal);
  }

  /// Increases the [WaterGoal.consumedVolume] column of current date
  /// by [consumedVolIncrease]
  Future<int> updateConsumedVolume(int consumedVolIncrease) async {
    final goal = await getGoal(DateTime.now());
    int gap = await calcReminderGap(null, null);

    return (update(waterGoals)..where((t) => t.date.equals(goal!.date))).write(
        WaterGoalsCompanion(
            consumedVolume: Value(goal!.consumedVolume + consumedVolIncrease),
            reminderGap: Value(gap)));
  }

  /// Increases the [WaterGoal.totalVolume] column of current date
  /// by [totalVolIncrease]
  Future<int> updateTotalVolume(int totalVolIncrease) async {
    final goal = await getGoal(DateTime.now());
    int newTotalVol = totalVolIncrease + goal!.totalVolume;
    int gap = await calcReminderGap(null, null);

    return (update(waterGoals)..where((t) => t.date.equals(goal.date))).write(
        WaterGoalsCompanion(
            totalVolume: Value(newTotalVol), reminderGap: Value(gap)));
  }
}
