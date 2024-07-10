import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils/icons.dart';

class WorkoutDurationPieChart extends StatefulWidget {
  const WorkoutDurationPieChart({super.key, required this.workouts});

  final Map<Activity, int> workouts;

  @override
  State<WorkoutDurationPieChart> createState() =>
      _WorkoutDurationPieChartState();
}

class _WorkoutDurationPieChartState extends State<WorkoutDurationPieChart> {
  int touchedIndex = -1;

  Map<String, int> getGroupedByCategory(Map<Activity, int> activities) {
    Map<String, int> groupedActivities = {};

    for (final activity in activities.keys) {
      String name = activity.category;
      int duration = activities[activity]!;
      if (groupedActivities.containsKey(name)) {
        int existingDuration = groupedActivities[name]!;
        groupedActivities[name] = existingDuration + duration;
      } else {
        groupedActivities[name] = duration;
      }
    }
    return groupedActivities;
  }

  List<PieChartSectionData> workoutPieSections(Map<Activity, int> activities) {
    Map<String, int> workouts = getGroupedByCategory(activities);

    return List.generate(workouts.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 90.0 : 80.0;
      String name = workouts.keys.toList()[i];
      Color color = workoutIconMap[name]![1];

      return PieChartSectionData(
          showTitle: isTouched,
          title: "\t$name: ${workouts[name]} mins",
          titleStyle: TextStyle(
              backgroundColor: Colors.black.withOpacity(0.3),
              fontWeight: FontWeight.w900,
              fontSize: fontSize,
              color: Colors.white),
          titlePositionPercentageOffset: 0,
          value: workouts[name]!.toDouble(),
          color: color,
          radius: radius);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PieChart(PieChartData(
        centerSpaceRadius: 0,
        startDegreeOffset: 70,
        borderData: FlBorderData(show: false),
        sections: workoutPieSections(widget.workouts),
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        )));
  }
}
