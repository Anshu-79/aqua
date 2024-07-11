import 'package:drift/drift.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils/shared_pref_utils.dart';
import 'package:aqua/utils/miscellaneous.dart';

/// Extension on the `Database` class to provide workout-related queries.
extension WorkoutQueries on Database {

  /// Fetches all items in [workouts] for the day
  /// Note that the current datetime is first shifted to wakeTime
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

  /// Simply fetches all items in [workouts]
  Future<List<Workout>> getAllWorkouts() async => await select(workouts).get();

  /// Tries to insert an item into [workouts]
  /// If failed due to conflict, it updates said [Workout]
  Future<int> insertOrUpdateWorkout(WorkoutsCompanion entity) async {
    return await into(workouts).insertOnConflictUpdate(entity);
  }
}
