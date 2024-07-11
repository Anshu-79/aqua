import 'package:drift/drift.dart';

import 'package:aqua/database/database.dart';

/// Extension on the `Database` class to provide activity-related queries.
extension ActivityQueries on Database {
  /// Fetches all items in [activities]
  Future<List<Activity>> getActivities() async {
    return await select(activities).get();
  }

  /// Fetches a single [Activity] by [Activity.id]
  Future<Activity> getActivity(int id) async {
    return await (select(activities)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  /// Fetches a mapping of each [Activity] & the total amount of time spent doing it
  /// groups them together based on the [Activity.category]
  Future<Map<Activity, int>> totalDurationPerActivity() async {
    final query = selectOnly(workouts)
      ..addColumns([workouts.activityID, workouts.duration.sum()]);
    query.groupBy([workouts.activityID]);

    final result = await query.get();

    final activityIDs =
        result.map((row) => row.read(workouts.activityID)).toList();

    final Map<Activity, int> aggregatedData = {};
    for (final id in activityIDs) {
      final totalDuration = result
          .where((row) => row.read(workouts.activityID) == id)
          .map<int>((row) => row.read(workouts.duration.sum()) as int)
          .reduce((value, element) => value + element);

      final activity = await (select(activities)
            ..where((tbl) => tbl.id.equals(id!)))
          .getSingle();

      aggregatedData[activity] = totalDuration;
    }
    return aggregatedData;
  }
}
