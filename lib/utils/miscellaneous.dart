import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'package:aqua/utils/shared_pref_utils.dart';

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

Future<DateTime> convertToWaterGoalID(DateTime dt) async {
  // Explanation at function's definition
  DateTime today = await shiftToWakeTime(dt);

  // Convert datetime to a date since primary key is the date
  DateTime dateOnly = DateUtils.dateOnly(today);
  return dateOnly;
}
