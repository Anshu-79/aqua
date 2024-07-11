import 'package:flutter/material.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/screens/activity_menu/helpers.dart';
import 'package:aqua/utils/miscellaneous.dart' as utils;

/// Displays the icon, category, duration and sweat loss for a [Workout] 
class WorkoutCard extends StatelessWidget {
  const WorkoutCard({super.key, required this.workout});
  final Workout workout;

  @override
  Widget build(BuildContext context) {
    Color bgColor = getWorkoutColor(workout.activityID);
    Color primaryColor = Theme.of(context).primaryColor;

    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: bgColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: bgColor, width: 5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(getWorkoutIcon(workout.activityID),
              color: primaryColor, size: 50),
          FittedBox(
              fit: BoxFit.contain,
              child: Text(getWorkoutCategory(workout.activityID),
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: primaryColor))),
          Text(utils.getDurationInText(workout.duration),
              style:
                  TextStyle(color: primaryColor, fontWeight: FontWeight.w900)),
          Text(utils.getVolumeInText(workout.waterLoss),
              style:
                  TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
