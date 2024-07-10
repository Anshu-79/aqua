import 'package:flutter/material.dart';

import 'package:aqua/utils/icons.dart';

IconData getWorkoutIcon(int activityID) {
  int categoryCode = (activityID ~/ 1000) - 1;
  return workoutIconMap.values.toList()[categoryCode][0];
}

Color getWorkoutColor(int activityID) {
  int categoryCode = (activityID ~/ 1000) - 1;
  return workoutIconMap.values.toList()[categoryCode][1];
}

String getWorkoutCategory(int activityID) {
  int categoryCode = (activityID ~/ 1000) - 1;
  return workoutIconMap.keys.toList()[categoryCode];
}
