import 'package:drift/drift.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils/shared_pref_utils.dart';
import 'package:aqua/utils/miscellaneous.dart';

/// Extension on the `Database` class to provide workout-related queries.
extension WorkoutQueries on Database {
  /// Fetches all items in [workouts] for the day & the associated [Activity]
  /// in the form of a map between a [Workout] and an [Activity]
  /// Note that the current datetime is first shifted to wakeTime
  Future<Map<Workout,Activity>> getTodaysWorkouts() async {
    DateTime now = DateTime.now();
    now = await shiftToWakeTime(now);
    final int wakeHour = await SharedPrefUtils.getWakeTime();
    final todayStart = DateTime(now.year, now.month, now.day, wakeHour);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final query = select(workouts).join(
      [innerJoin(activities, activities.id.equalsExp(workouts.activityID))],
    )..where(workouts.datetime.isBetweenValues(todayStart, todayEnd));

    final result = await query.get();
    final Map<Workout, Activity> workoutActivityMap = {};

    for (final row in result) {
      final workout = row.readTable(workouts);
      final activity = row.readTable(activities);
      workoutActivityMap[workout] = activity;
    }

    return workoutActivityMap;
  }

  /// Simply fetches all items in [workouts]
  Future<List<Workout>> getAllWorkouts() async => await select(workouts).get();

  /// Tries to insert an item into [workouts]
  /// If failed due to conflict, it updates said [Workout]
  Future<int> insertOrUpdateWorkout(WorkoutsCompanion entity) async {
    return await into(workouts).insertOnConflictUpdate(entity);
  }
}
