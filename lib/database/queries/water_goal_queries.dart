import 'package:drift/drift.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/shared_pref_utils.dart';
import 'package:aqua/utils.dart';
import 'package:aqua/water_goals.dart';

extension WaterGoalQueries on Database {
  Future<List<WaterGoal>> getWaterGoals() async =>
      await select(waterGoals).get();

  Future<WaterGoal?> getGoal(DateTime datetime) async {
    final DateTime dateOnly = await convertToWaterGoalID(datetime);

    return await (select(waterGoals)..where((tbl) => tbl.date.equals(dateOnly)))
        .getSingleOrNull();
  }

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

  Future<int> updateConsumedVolume(int consumedVolIncrease) async {
    final goal = await getGoal(DateTime.now());
    int gap = await calcReminderGap(null, null);

    return (update(waterGoals)..where((t) => t.date.equals(goal!.date))).write(
        WaterGoalsCompanion(
            consumedVolume: Value(goal!.consumedVolume + consumedVolIncrease),
            reminderGap: Value(gap)));
  }

  Future<int> updateTotalVolume(int totalVolIncrease) async {
    final goal = await getGoal(DateTime.now());
    int newTotalVol = totalVolIncrease + goal!.totalVolume;
    int gap = await calcReminderGap(null, null);

    return (update(waterGoals)..where((t) => t.date.equals(goal.date))).write(
        WaterGoalsCompanion(
            totalVolume: Value(newTotalVol), reminderGap: Value(gap)));
  }
}
