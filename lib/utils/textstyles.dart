import 'package:flutter/material.dart';

import 'package:aqua/utils/colors.dart';

abstract class HomeScreenStyles {
  static TextStyle goal = const TextStyle(
      fontWeight: FontWeight.w900, color: AquaColors.darkBlue, fontSize: 400);

  static TextStyle goalSubtext =
      TextStyle(fontWeight: FontWeight.bold, fontSize: goal.fontSize! / 4);
}

abstract class ProfileScreenStyles {
  static TextStyle username = const TextStyle(
      fontSize: 100, fontWeight: FontWeight.bold, color: Colors.black);

  static TextStyle userLocation = const TextStyle(
      fontSize: 100, fontWeight: FontWeight.bold, color: Colors.white);

  static TextStyle biometricInfo = const TextStyle(
      color: Colors.black, fontWeight: FontWeight.w900, fontSize: 60);

  static TextStyle biometricInfoSubtext = const TextStyle(
      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25);

  static TextStyle sleepInfo = const TextStyle(
      color: Colors.black, fontWeight: FontWeight.w900, fontSize: 50);

  static TextStyle userStats =
      const TextStyle(fontSize: 100, fontWeight: FontWeight.w900);

  static TextStyle userStatsSubtext =
      const TextStyle(fontSize: 50, fontWeight: FontWeight.bold);
}

abstract class BeverageMenuStyles {
  static TextStyle nameStyle =
      const TextStyle(fontSize: 40, fontWeight: FontWeight.w900);

  static TextStyle subtextStyle =
      const TextStyle(fontSize: 15, fontWeight: FontWeight.normal);

  static TextStyle waterPercentStyle =
      const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
}

abstract class ActivityMenuStyle {
  static TextStyle activityNameStyle =
      const TextStyle(fontSize: 30, fontWeight: FontWeight.w900);
  static TextStyle cardSubtext =
      const TextStyle(fontSize: 15, fontWeight: FontWeight.w500);
  static TextStyle activityDescriptionStyle = const TextStyle(fontSize: 15);
  static TextStyle workoutDurationStyle =
      const TextStyle(fontSize: 15, fontWeight: FontWeight.w900);
  static TextStyle workoutWaterLossStyle =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.w900);
}
