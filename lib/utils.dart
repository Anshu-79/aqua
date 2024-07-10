import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:aqua/shared_pref_utils.dart';
import 'package:aqua/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:aqua/main.dart';

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

String getTimeInText(int time) {
  if (time > 12) return "${time - 12}:00 PM";
  if (time == 12) return "12:00 PM";
  return "$time:00 AM";
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
      fontSize: 100, fontWeight: FontWeight.w900, color: AquaColors.darkBlue);

  static TextStyle dailyGoalTotal = TextStyle(
      color: AquaColors.darkBlue,
      fontSize: dailyGoalConsumed.fontSize,
      fontWeight: FontWeight.w900);

  static TextStyle dailyGoalFillerText = const TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.bold,
  );

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
      fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black);

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

  // Workout Dialog Boxes
  static TextStyle searchLabelText =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  static TextStyle listTileTitle = const TextStyle(fontWeight: FontWeight.bold);

  // Settings Page
  static TextStyle themeToggle =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 17);

  static TextStyle settingsHeader =
      const TextStyle(fontSize: 40, fontWeight: FontWeight.w900);
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
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).canvasColor,
      ),
      onPressed: () => function(),
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
        duration: const Duration(milliseconds: 1000),
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
            child: const Placeholder());

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
        title: FittedBox(
          fit: BoxFit.contain,
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              ColorizeAnimatedText(
                title,
                textStyle: screenHeader,
                speed: const Duration(milliseconds: 500),
                colors: AquaColors.allColors.sublist(0, 9).reversed.toList(),
              )
            ],
          ),
        ));
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
        backgroundColor: Theme.of(context).primaryColor,
        splashColor: Theme.of(context).splashColor,
        shape: const CircleBorder(eccentricity: 0),
        onPressed: () => onPressed(),
        child: Icon(Icons.add, color: Theme.of(context).canvasColor, size: 30),
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
  return dateOnly;
}
