import 'package:flutter/material.dart';
import 'icomoon_icons.dart';

// Color Utilities
Map<String, Color> defaultColors = {
  'red': const Color(0xFFff595e),
  'orange': const Color(0xffff924c),
  'yellow': const Color(0xffffca3a),
  'green': const Color(0xff8ac926),
  'blue': const Color(0xFF44A4EE),
  'violet': const Color(0xFF6a4c93),
};

List<Color> colorList = defaultColors.values.toList();

Color toColor(String colorCode) => Color(int.parse('0x$colorCode'));

String toHexString(Color color) => color.value.toRadixString(16);

/// Darken a color by [percent] amount (100 = black)
Color darken(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  var f = 1 - percent / 100;
  return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
      (c.blue * f).round());
}

/// Lighten a color by [percent] amount (100 = white)
Color lighten(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  var p = percent / 100;
  return Color.fromARGB(
      c.alpha,
      c.red + ((255 - c.red) * p).round(),
      c.green + ((255 - c.green) * p).round(),
      c.blue + ((255 - c.blue) * p).round());
}

// Icon Utilities
const Map<String, IconData> icomoonMap = {
    'Bicycling': Icomoon.Bicycling,
    'Conditioning Exercise': Icomoon.Conditioning_Exercise,
    'Dancing': Icomoon.Dancing,
    'Fishing & Hunting': Icomoon.Fishing_and_Hunting,
    'Home Activities': Icomoon.Home_Activities,
    'Home Repair': Icomoon.Home_Repair,
    'Inactivity': Icomoon.Inactivity,
    'Lawn & Garden': Icomoon.Lawn_and_Garden,
    'Miscellaneous': Icomoon.Miscellaneous,
    'Music Playing': Icomoon.Music_Playing,
    'Occupation': Icomoon.Occupation,
    'Running': Icomoon.Running,
    'Self Care': Icomoon.Self_Care,
    'Sexual Activity': Icomoon.Sexual_Activity,
    'Sports': Icomoon.Sports,
    'Walking': Icomoon.Walking,
    'Water Activities': Icomoon.Water_Activities,
    'Winter Activities': Icomoon.Winter_Activities,
    'Religious Activities': Icomoon.Religious_Activities,
    'Volunteer Activities': Icomoon.Volunteer_Activities,
    'Video Games': Icomoon.Video_Games,
  };

  IconData getWorkoutIcon(int activityID) {
    int categoryCode = (activityID ~/ 1000) - 1;
    return icomoonMap.values.toList()[categoryCode];
  } 

// Font Utilities
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

  // List Beverage Dialog Box
  static TextStyle ListBeverageName = const TextStyle(
      fontSize: 45, fontWeight: FontWeight.w900, color: Colors.black);

  static TextStyle ListBeverageTitle = const TextStyle(
      fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'CeraPro');

  // Beverage Dialog Boxes
  static TextStyle dialogSubtext = const TextStyle(
      fontSize: 45, fontWeight: FontWeight.w900, color: Colors.black);

  static TextStyle textInput = const TextStyle(
      fontSize: 35, fontWeight: FontWeight.w900, color: Colors.black);

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

  // Workout Screen
  static TextStyle emptyScreenText = 
    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600); 
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
