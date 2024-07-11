import 'package:flutter/material.dart';

import 'package:aqua/utils/colors.dart';

abstract class HomeScreenStyles {
  static TextStyle goalConsumed = const TextStyle(
      fontSize: 100, fontWeight: FontWeight.w900, color: AquaColors.darkBlue);

  static TextStyle goalTotal = TextStyle(
      color: AquaColors.darkBlue,
      fontSize: goalConsumed.fontSize,
      fontWeight: FontWeight.w900);

  static TextStyle goalSubtext =
      const TextStyle(fontSize: 35, fontWeight: FontWeight.bold);
}

abstract class ProfileScreenStyles {
  static TextStyle username = const TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black);

  static TextStyle userLocation = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white);

  static TextStyle biometricInfo = const TextStyle(
      color: Colors.black, fontWeight: FontWeight.w900, fontSize: 30);

  static TextStyle biometricInfoSubtext = const TextStyle(
      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12);

  static TextStyle sleepInfo = const TextStyle(
      color: Colors.black, fontWeight: FontWeight.w900, fontSize: 20);

  static TextStyle userStats =
      const TextStyle(fontSize: 24, fontWeight: FontWeight.w900);

  static TextStyle userStatsSubtext =
      const TextStyle(fontSize: 10, fontWeight: FontWeight.bold);
}

abstract class BeverageMenuStyles {
  static TextStyle nameStyle =
      const TextStyle(fontSize: 40, fontWeight: FontWeight.bold);

  static TextStyle subtextStyle =
      const TextStyle(fontSize: 15, fontWeight: FontWeight.normal);

  static TextStyle waterPercentStyle =
      const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
}