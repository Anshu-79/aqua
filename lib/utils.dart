import 'package:flutter/material.dart';

Map<String, Color> defaultColors = {
  'red': Color(0xFFff595e),
  'orange': Color(0xffff924c),
  'yellow': Color(0xffffca3a),
  'green': Color(0xff8ac926),
  'blue': Color(0xFF44A4EE),
  'violet': Color(0xFF6a4c93),
};

List<Color> colorList = defaultColors.values.toList();

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

  // Add Drink Dialog Box
  static TextStyle dialogButtons =
      const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static TextStyle dialogText = const TextStyle(
      fontSize: 45, fontWeight: FontWeight.w900, color: Colors.black);

  // Add Beverage Dialog Box
  static TextStyle dialogSubtext = const TextStyle(
      fontSize: 45, fontWeight: FontWeight.w900, color: Colors.black);

  static TextStyle textInput = const TextStyle(
      fontSize: 30, fontWeight: FontWeight.w900, color: Colors.black);

  static TextStyle textInputHint = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey);

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

class addDrinkDialogButtons extends StatelessWidget {
  const addDrinkDialogButtons(
      {super.key, required this.icon, required this.function});
  final Icon icon;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      icon: icon,
      iconSize: 50,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.black),
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
      onPressed: () => function(),

      //Text(text, style: ThemeText.dialogButtons,)
    );
  }
}
