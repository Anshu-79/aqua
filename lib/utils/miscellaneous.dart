import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:aqua/utils/shared_pref_utils.dart';

// Unit Utilities
String getDurationInText(int duration, [breakLine = false]) {
  if (duration >= 60) {
    int hrs = duration ~/ 60;
    int minutes = duration % 60;

    if (minutes == 0) return "$hrs hrs";

    if (breakLine) return "$hrs hrs\n$minutes mins";

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

bool isHourBetween(int hourToCheck, int startHour, int endHour) {
  if (startHour <= endHour) {
    // Check within the same day
    return hourToCheck >= startHour && hourToCheck < endHour;
  } else {
    // Check across midnight
    return hourToCheck >= startHour || hourToCheck < endHour;
  }
}

/// A simple widget which applies a border to the passed text
/// If strokeWidth is not passed, it is set to be 1/30th of the displayed font size
class BorderedText extends StatefulWidget {
  const BorderedText({
    super.key,
    required this.text,
    required this.textStyle,
    this.strokeWidth,
  });
  final String text;
  final TextStyle textStyle;
  final double? strokeWidth;

  @override
  State<BorderedText> createState() => _BorderedTextState();
}

class _BorderedTextState extends State<BorderedText> {
  double strokeWidth = 5;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double measuredHeight = _measureText();
      setState(() => strokeWidth = widget.strokeWidth ?? measuredHeight / 30);
    });
    super.initState();
  }

  double _measureText() {
    final textPainter = TextPainter(
        text: TextSpan(text: widget.text, style: widget.textStyle),
        maxLines: 1,
        textDirection: TextDirection.ltr);

    textPainter.layout(maxWidth: MediaQuery.of(context).size.width);

    return textPainter.size.height;
  }

  @override
  Widget build(BuildContext context) {
    AutoSizeText goal = AutoSizeText(widget.text, style: widget.textStyle);

    TextStyle goalBorder = TextStyle(
        fontSize: widget.textStyle.fontSize,
        fontWeight: widget.textStyle.fontWeight,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = widget.strokeWidth ?? strokeWidth
          ..color = Colors.black);

    AutoSizeText goalBorderText = AutoSizeText(widget.text, style: goalBorder);
    return Stack(children: [goalBorderText, goal]);
  }
}

/// A [TypewriterAnimatedText] that displays questions during the Onboarding Flow
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
