import 'package:flutter/material.dart';

abstract class ThemeText {
  static const TextStyle screenHeader =
      TextStyle(fontSize: 45, fontWeight: FontWeight.w900);

  // Home Screen
  static TextStyle dailyGoalConsumed = const TextStyle(
      fontSize: 100, fontWeight: FontWeight.w900, color: Color(0xFF44A4EE));

  static TextStyle dailyGoalTotal = TextStyle(
      color: const Color(0xFF2286D3),
      fontSize: dailyGoalConsumed.fontSize,
      fontWeight: FontWeight.w900);

  static TextStyle dailyGoalBorder = TextStyle(
    fontSize: dailyGoalConsumed.fontSize,
    fontWeight: FontWeight.w900,
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.black,
  );

  static TextStyle dailyGoalFillerText = const TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.bold,
  );

  static TextStyle reminderSubText =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.normal);

  static TextStyle reminderText = const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Color(0xFF44A4EE),
      letterSpacing: 3);


  // Beverage Menu
  static TextStyle beverageName =
      const TextStyle(fontSize: 40, fontWeight: FontWeight.bold);

  static TextStyle beverageSubtext =
      const TextStyle(fontSize: 15, fontWeight: FontWeight.normal);

  static TextStyle beverageWaterPercentage =
      const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);


  // User Profile
  static TextStyle username = const TextStyle(
      fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white);

  static TextStyle userLocationSubtext = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white);

  static TextStyle userInfo = const TextStyle(
      color: Colors.black, fontWeight: FontWeight.w900, fontSize: 30);

  static TextStyle userInfoSubtext = const TextStyle(
      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12);

  static TextStyle userStats =
      const TextStyle(fontSize: 24, fontWeight: FontWeight.w900);

  static TextStyle userStatsSubtext =
      const TextStyle(fontSize: 10, fontWeight: FontWeight.bold);
      
}
