import 'package:drift/drift.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils/shared_pref_utils.dart';
import 'package:aqua/utils/miscellaneous.dart';

extension WorkoutQueries on Database {
  Future<List<Workout>> getTodaysWorkouts() async {
    DateTime now = DateTime.now();
    now = await shiftToWakeTime(now);
    final int wakeHour = await SharedPrefUtils.getWakeTime();
    final todayStart = DateTime(now.year, now.month, now.day, wakeHour);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final query = select(workouts)
      ..where((tbl) => tbl.datetime.isBetweenValues(todayStart, todayEnd));

    return query.get();
  }

  Future<List<Workout>> getAllWorkouts() async => await select(workouts).get();

  Future<int> insertOrUpdateWorkout(WorkoutsCompanion entity) async {
    return await into(workouts).insertOnConflictUpdate(entity);
  }
}
