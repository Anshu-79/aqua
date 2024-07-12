import 'package:aqua/utils/textstyles.dart';
import 'package:flutter/material.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/screens/activity_menu/helpers.dart';
import 'package:aqua/utils/miscellaneous.dart' as utils;

/// Displays the icon, category, duration and sweat loss for a [Workout]
class WorkoutCard extends StatelessWidget {
  const WorkoutCard({super.key, required this.workout, required this.activity});
  final Workout workout;
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    Color bgColor = getWorkoutColor(workout.activityID);
    Color primaryColor = Theme.of(context).primaryColor;

    return Container(
        margin: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
            color: bgColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: bgColor, width: 5)),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Column(children: [
            Icon(getWorkoutIcon(activity.id), color: primaryColor, size: 60),
            const SizedBox(height: 10),
            durationText()
          ]),
          const SizedBox(width: 20),
          Flexible(
              child: Wrap(
            alignment: WrapAlignment.start,
            runSpacing: 5,
            children: [categoryText(), descriptionText(), waterLossText()],
          ))
        ]));
  }

  Widget durationText() {
    return Text(utils.getDurationInText(workout.duration, true),
        style: ActivityMenuStyle.workoutDurationStyle,
        maxLines: 2,
        textAlign: TextAlign.center);
  }

  Widget categoryText() {
    return FittedBox(
        fit: BoxFit.contain,
        child: Text(activity.category,
            style: ActivityMenuStyle.activityNameStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis));
  }

  Widget descriptionText() {
    return Text(activity.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: ActivityMenuStyle.activityDescriptionStyle);
  }

  Widget waterLossText() {
    return Row(
      children: [
        Text("Water Loss: ", style: ActivityMenuStyle.cardSubtext),
        Text(utils.getVolumeInText(workout.waterLoss),
            style: ActivityMenuStyle.workoutWaterLossStyle),
      ],
    );
  }
}
