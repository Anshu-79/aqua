import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:aqua/main.dart';
import 'icomoon_icons.dart';

// Theme Utilities
ThemeData lightTheme = ThemeData(
    fontFamily: 'CeraPro',
    primaryColor: Colors.black,
    canvasColor: Colors.white,
    splashColor: defaultColors['blue'],
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
        seedColor: defaultColors['dark blue']!.toMaterialColor(),
        brightness: Brightness.light));

ThemeData darkTheme = ThemeData(
    fontFamily: 'CeraPro',
    primaryColor: Colors.white,
    canvasColor: Colors.black,
    splashColor: defaultColors['blue'],
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
        seedColor: defaultColors['dark blue']!.toMaterialColor(),
        brightness: Brightness.dark));

// Duration Utilities
String getInText(int duration) {
  if (duration < 60) {
    return "$duration minutes";
  } else {
    int hrs = duration ~/ 60;
    int minutes = duration % 60;

    if (minutes == 0) {
      return "$hrs hours";
    } else {
      return "$hrs hours $minutes minutes";
    }
  }
}

// Color Utilities
Map<String, Color> defaultColors = {
  'pink': const Color(0xFFFF789C),
  'red': const Color(0xFFff595e),
  'orange': const Color(0xffff924c),
  'yellow': const Color(0xffffca3a),
  'lime': const Color(0xFFCBD039),
  'green': const Color(0xff8ac926),
  'mint': const Color(0xFF4EA675),
  'blue': const Color(0xFF44A4EE),
  'dark blue': const Color(0xFF0264e1),
  'violet': const Color(0xFF9042F0),
};

List<Color> textColorizeColors = [
  defaultColors['dark blue']!,
  Colors.purple,
  Colors.pink,
  Colors.red,
  Colors.orange,
  Colors.yellow,
];

List<Color> colorList = defaultColors.values.toList();

List<Color> shapeColors = [
  defaultColors['red']!,
  defaultColors['yellow']!,
  defaultColors['green']!,
  defaultColors['blue']!,
];

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

extension ColorExt on Color {
  MaterialColor toMaterialColor() {
    final int red = this.red;
    final int green = this.green;
    final int blue = this.blue;

    final Map<int, Color> shades = {
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };
    return MaterialColor(value, shades);
  }
}

// Icon Utilities
Map<String, List<dynamic>> icomoonMap = {
  'Bicycling': [Icomoon.Bicycling, defaultColors['green']],
  'Conditioning Exercise': [
    Icomoon.Conditioning_Exercise,
    defaultColors['blue']
  ],
  'Dancing': [Icomoon.Dancing, defaultColors['red']],
  'Fishing & Hunting': [Icomoon.Fishing_and_Hunting, defaultColors['mint']],
  'Home Activities': [Icomoon.Home_Activities, defaultColors['yellow']],
  'Home Repair': [Icomoon.Home_Repair, defaultColors['red']],
  'Inactivity': [Icomoon.Inactivity, defaultColors['lime']],
  'Lawn & Garden': [Icomoon.Lawn_and_Garden, defaultColors['green']],
  'Miscellaneous': [Icomoon.Miscellaneous, defaultColors['mint']],
  'Music Playing': [Icomoon.Music_Playing, defaultColors['violet']],
  'Occupation': [Icomoon.Occupation, defaultColors['dark blue']],
  'Running': [Icomoon.Running, defaultColors['orange']],
  'Self Care': [Icomoon.Self_Care, defaultColors['pink']],
  'Sexual Activity': [Icomoon.Sexual_Activity, defaultColors['red']],
  'Sports': [Icomoon.Sports, defaultColors['blue']],
  'Transportation': [Icomoon.Transportation, defaultColors['yellow']],
  'Walking': [Icomoon.Walking, defaultColors['green']],
  'Water Activities': [Icomoon.Water_Activities, defaultColors['blue']],
  'Winter Activities': [Icomoon.Winter_Activities, defaultColors['dark blue']],
  'Religious Activities': [
    Icomoon.Religious_Activities,
    defaultColors['violet']
  ],
  'Volunteer Activities': [
    Icomoon.Volunteer_Activities,
    defaultColors['green']
  ],
  'Video Games': [Icomoon.Video_Games, defaultColors['blue']],
};

IconData getWorkoutIcon(int activityID) {
  int categoryCode = (activityID ~/ 1000) - 1;
  return icomoonMap.values.toList()[categoryCode][0];
}

Color getWorkoutColor(int activityID) {
  int categoryCode = (activityID ~/ 1000) - 1;
  return icomoonMap.values.toList()[categoryCode][1];
}

String getWorkoutCategory(int activityID) {
  int categoryCode = (activityID ~/ 1000) - 1;
  return icomoonMap.keys.toList()[categoryCode];
}

// Font Utilities
abstract class ThemeText {
  static const TextStyle screenHeader =
      TextStyle(fontSize: 45, fontWeight: FontWeight.w900);

  // Onboarding Screens

  static const TextStyle nameInputField =
      TextStyle(fontSize: 40, fontWeight: FontWeight.w900);

  static TextStyle formHint = const TextStyle(
      fontSize: 40, fontWeight: FontWeight.bold, color: Colors.grey);

  // Home Screen
  static TextStyle dailyGoalConsumed = const TextStyle(
      fontSize: 100, fontWeight: FontWeight.w900, color: Color(0xFF44A4EE));

  static TextStyle dailyGoalTotal = TextStyle(
      color: defaultColors['dark blue'],
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

  static TextStyle addDrinkBeverageName = const TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w900,
    color: Colors.black,
  );

  static TextStyle addDrinkDialogText = const TextStyle(
      fontSize: 45, fontWeight: FontWeight.w900, color: Colors.black);

  // List Beverage Dialog Box
  static TextStyle ListBeverageName = const TextStyle(
      fontSize: 45, fontWeight: FontWeight.w900, color: Colors.black);

  static TextStyle ListBeverageTitle = const TextStyle(
      fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'CeraPro');

  // Beverage Dialog Boxes
  static TextStyle dialogSubtext = const TextStyle(
      fontSize: 40, fontWeight: FontWeight.w900, color: Colors.black);

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

  // Workout Screen
  static TextStyle emptyScreenText =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.w600);

  // Workout Dialog Boxes
  static TextStyle searchLabelText =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  static TextStyle listTileTitle = const TextStyle(fontWeight: FontWeight.bold);

  static TextStyle workoutTitle = const TextStyle(
      fontSize: 40, fontWeight: FontWeight.w900, color: Colors.black);

  static TextStyle durationSubtext =
      const TextStyle(fontSize: 30, fontWeight: FontWeight.w900);
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
      style: IconButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      onPressed: () => function(),

      //Text(text, style: ThemeText.dialogButtons,)
    );
  }
}

SnackBar coloredSnackBar(Color color, String text) {
  return SnackBar(
    duration: const Duration(seconds: 1),
    content: Text(
      text,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: color,
    action: SnackBarAction(
      label: 'Dismiss',
      textColor: Colors.white,
      onPressed: () {},
    ),
  );
}

Stack borderedText(String text, TextStyle style, TextStyle borderStyle) {
  return Stack(children: [
    Text.rich(TextSpan(children: [
      TextSpan(text: text, style: borderStyle),
    ])),
    Text.rich(TextSpan(children: [
      TextSpan(text: text, style: style),
    ])),
  ]);
}

class GlobalNavigator {
  static showAlertDialog(String text) {
    showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return AlertDialog(
            title: const Text("Permission denied"),
            content: Text(text),
            actions: [
              TextButton(
                  onPressed: () async {
                    await openAppSettings();
                  },
                  child: const Text("Open Settings")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Continue")),
            ],
          );
        });
  }
}

class OnboardingQuestion extends StatefulWidget {
  const OnboardingQuestion({super.key, required this.text});

  final String text;

  @override
  State<OnboardingQuestion> createState() => _OnboardingQuestionState();
}

class _OnboardingQuestionState extends State<OnboardingQuestion> {
  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      totalRepeatCount: 1,
      animatedTexts: [
        TypewriterAnimatedText(
          widget.text,
          textStyle: const TextStyle(fontSize: 50, fontWeight: FontWeight.w800),
          textAlign: TextAlign.center,
          cursor: '|',
          speed: const Duration(milliseconds: 100),
        ),
      ],
    );
  }
}
