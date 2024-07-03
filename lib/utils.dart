import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:aqua/shared_pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:aqua/main.dart';
import 'icomoon_icons.dart';

// Theme Utilities
ThemeData lightTheme = ThemeData(
    fontFamily: 'CeraPro',
    primaryColor: Colors.black,
    canvasColor: Colors.white,
    splashColor: defaultColors['dark blue'],
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
        seedColor: defaultColors['dark blue']!.toMaterialColor(),
        brightness: Brightness.light));

ThemeData darkTheme = ThemeData(
    fontFamily: 'CeraPro',
    primaryColor: Colors.white,
    canvasColor: Colors.black,
    splashColor: defaultColors['dark blue'],
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
        seedColor: defaultColors['dark blue']!.toMaterialColor(),
        brightness: Brightness.dark));

// Unit Utilities
String getDurationInText(int duration) {
  if (duration >= 60) {
    int hrs = duration ~/ 60;
    int minutes = duration % 60;

    if (minutes == 0) return "$hrs hrs";

    return "$hrs hrs $minutes mins";
  }

  return "$duration mins";
}

String getVolumeInText(int volume) {
  if (volume >= 1000) {
    double litres = volume / 1000;
    return "${litres.toStringAsFixed(3)} L";
  }

  return "$volume mL";
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

Color adjustColorContrast(Color color, double factor) {
  int adjustChannel(int channel) {
    double normalized = channel / 255.0;
    double adjusted = ((normalized - 0.5) * factor + 0.5).clamp(0.0, 1.0);
    return (adjusted * 255).round();
  }

  return Color.fromARGB(
    color.alpha,
    adjustChannel(color.red),
    adjustChannel(color.green),
    adjustChannel(color.blue),
  );
}

Color visibilityCheck(Color color) =>
    color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

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
  // Onboarding Screens

  static const TextStyle nameInputField =
      TextStyle(fontSize: 40, fontWeight: FontWeight.w900);

  static TextStyle formHint = const TextStyle(
      fontSize: 40, fontWeight: FontWeight.bold, color: Colors.grey);

  // Home Screen
  static TextStyle dailyGoalConsumed = TextStyle(
      fontSize: 100,
      fontWeight: FontWeight.w900,
      color: defaultColors['dark blue']);

  static TextStyle dailyGoalTotal = TextStyle(
      color: defaultColors['dark blue'],
      fontSize: dailyGoalConsumed.fontSize,
      fontWeight: FontWeight.w900);

  static TextStyle dailyGoalFillerText = const TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.bold,
  );

  static TextStyle reminderSubText =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  static TextStyle reminderText = TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w900,
      color: defaultColors['dark blue']);

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
}

class DialogActionButton extends StatelessWidget {
  const DialogActionButton(
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

class BorderedText extends StatelessWidget {
  const BorderedText(
      {super.key,
      required this.text,
      required this.textStyle,
      required this.strokeWidth});
  final String text;
  final TextStyle textStyle;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    TextStyle dailyGoalBorder = TextStyle(
        fontSize: textStyle.fontSize,
        fontWeight: textStyle.fontWeight,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..color = Colors.black);

    return Stack(children: [
      Text.rich(TextSpan(children: [
        TextSpan(text: text, style: dailyGoalBorder),
      ])),
      Text.rich(TextSpan(children: [TextSpan(text: text, style: textStyle)])),
    ]);
  }
}

class BorderedIcon extends StatelessWidget {
  const BorderedIcon(
      {super.key,
      required this.iconData,
      required this.color,
      required this.size,
      required this.borderColor});
  final IconData iconData;
  final Color color;
  final Color borderColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Icon(iconData, size: size + 2, color: borderColor),
        Icon(iconData, size: size, color: color)
      ],
    );
  }
}

class GlobalNavigator {
  static void showSnackBar(String text, Color? color) {
    BuildContext context = navigatorKey.currentContext!;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 500),
        content: Text(text,
            style: TextStyle(
              color: Theme.of(context).canvasColor,
            )),
        backgroundColor: color,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Theme.of(context).canvasColor,
          onPressed: () {},
        )));
  }

  static Future<dynamic>? showAlertDialog(
      String text, Widget? backupData) async {
    return await showDialog(
        barrierDismissible: false,
        context: navigatorKey.currentContext!,
        builder: (context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              title: const Text("Permission denied"),
              content: Text(text),
              actions: [
                TextButton(
                    onPressed: () async => await openAppSettings(),
                    child: const Text("Open Settings")),
                TextButton(
                    onPressed: () async {
                      if (backupData != null) {
                        final val = await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return PopScope(canPop: false, child: backupData);
                            });
                        if (context.mounted) Navigator.pop(context, val);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Continue")),
              ],
            ),
          );
        });
  }

  static Future<dynamic>? showAnimatedDialog(Widget dialog) async {
    return await showGeneralDialog(
      context: navigatorKey.currentContext!,
      transitionDuration: const Duration(milliseconds: 500),
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) => const Placeholder(),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * -200, 0.0),
          child: Opacity(opacity: a1.value, child: dialog),
        );
      },
    );
  }
}

class OnboardingQuestion extends StatelessWidget {
  const OnboardingQuestion({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      totalRepeatCount: 1,
      animatedTexts: [
        TypewriterAnimatedText(
          text,
          textStyle: const TextStyle(fontSize: 50, fontWeight: FontWeight.w800),
          textAlign: TextAlign.center,
          cursor: '|',
          speed: const Duration(milliseconds: 100),
        ),
      ],
    );
  }
}

class UniversalHeader extends PreferredSize {
  const UniversalHeader({super.key, required this.title})
      : super(
          preferredSize: const Size.fromHeight(60),
          child: const Placeholder(),
        );

  final String title;

  @override
  Widget build(BuildContext context) {
    TextStyle screenHeader = TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 45,
        fontWeight: FontWeight.w900,
        fontFamily: "CeraPro");

    return AppBar(
      backgroundColor: Theme.of(context).canvasColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: screenHeader,
      title: FittedBox(fit: BoxFit.contain, child: Text(title)),
    );
  }
}

class UniversalFAB extends StatelessWidget {
  const UniversalFAB(
      {super.key, required this.tooltip, required this.onPressed});
  final String tooltip;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 70,
      child: FloatingActionButton(
        tooltip: tooltip,
        backgroundColor: Theme.of(context).splashColor,
        splashColor: Theme.of(context).primaryColor,
        shape: const CircleBorder(eccentricity: 0),
        onPressed: () => onPressed(),
        child: Icon(Icons.add, color: Theme.of(context).primaryColor, size: 30),
      ),
    );
  }
}

// Manipulates a DateTime object into starting at the wakeTime of a user
// ensuring that goal is reset at WakeTime instead of 12 AM
// TL:DR - Shifts the point at which a new day starts to wakeTime
Future<DateTime> shiftToWakeTime(DateTime dt) async {
  int? wakeTime = await SharedPrefUtils.readInt('wakeTime');

  if (wakeTime == null) return dt;

  DateTime wakeUpToday = DateTime(dt.year, dt.month, dt.day, wakeTime);

  if (dt.isBefore(wakeUpToday)) {
    dt = wakeUpToday.subtract(const Duration(days: 1));
  }
  return dt;
}

// Does the opposite of its twin shiftToWakeTime
Future<DateTime> shiftToMidnight(DateTime dt, int offsetHrs) async {
  DateTime wakeUpToday = DateTime(dt.year, dt.month, dt.day, offsetHrs);

  if (dt.isBefore(wakeUpToday)) {
    dt = wakeUpToday.add(const Duration(days: 1));
  }
  return dt;
}

Future<DateTime> convertToWaterGoalID(DateTime dt) async {
  // Explanation at function's definition
  DateTime today = await shiftToWakeTime(dt);

  // Convert datetime to a date since primary key is the date
  DateTime dateOnly = DateUtils.dateOnly(today);
  print("now = $dt");
  print("today = $today");
  print("dateOnly = $dateOnly");
  return dateOnly;
}
