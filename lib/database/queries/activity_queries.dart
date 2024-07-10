import 'package:drift/drift.dart';

import 'package:aqua/database/database.dart';

extension ActivityQueries on Database {
  Future<List<Activity>> getActivities() async {
    return await select(activities).get();
  }

  Future<Activity> getActivity(int id) async {
    return await (select(activities)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

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
