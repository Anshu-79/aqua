import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/notifications.dart';

bool isSleepTime(SharedPreferences prefs) {
  int sleepTime = prefs.getInt('sleepTime') ?? 0;
  int wakeTime = prefs.getInt('wakeTime') ?? 8;

  int nowHr = DateTime.now().hour;

  bool beforeSleeping = nowHr < min(wakeTime, sleepTime);
  bool afterSleeping = nowHr > max(wakeTime, sleepTime);

  if (!beforeSleeping && !afterSleeping) return true;
  return false;
}

Widget getStyledText(String prefix, String styledText, String suffix,
    TextStyle subTextStyle, TextStyle styledTextStyle) {
  return Text.rich(
    TextSpan(
      text: "$prefix ",
      style: subTextStyle,
      children: <TextSpan>[
        TextSpan(text: styledText, style: styledTextStyle),
        TextSpan(text: ' $suffix', style: subTextStyle),
      ],
    ),
  );
}

class ReminderBox extends StatefulWidget {
  const ReminderBox({super.key, required this.prefs, required this.db});
  final SharedPreferences prefs;
  final Database db;

  @override
  State<ReminderBox> createState() => _ReminderBoxState();
}

class _ReminderBoxState extends State<ReminderBox> {
  late bool remindersON;
  late bool isNotSleepTime;

  @override
  void initState() {
    bool userReminderPref = widget.prefs.getBool('reminders') ?? true;
    isNotSleepTime = !isSleepTime(widget.prefs);

    remindersON = userReminderPref && isNotSleepTime;
    super.initState();
  }

  void _toggled(bool b) async {
    setState(() => remindersON = b);
    widget.prefs.setBool('reminders', b);
    if (b) {
      NotificationsController.createHydrationNotification(
          await widget.db.calcReminderGap(),
          await widget.db.calcMedianDrinkSize());
    } else {
      NotificationsController.cancelScheduledNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color canvasColor = Theme.of(context).canvasColor;

    ToggleStyle toggleStyle = ToggleStyle(
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      backgroundColor: canvasColor,
      borderColor: primaryColor,
      indicatorBorderRadius: const BorderRadius.all(Radius.circular(20)),
      indicatorColor: remindersON
          ? Colors.green
          : isNotSleepTime
              ? Colors.red
              : Colors.purple,
    );
    return AnimatedToggleSwitch.dual(
      inactiveOpacity: 0.9,
      fittingMode: FittingMode.none,
      active: !isSleepTime(widget.prefs),
      indicatorSize: const Size.fromWidth(100),
      height: 120,
      borderWidth: 4,
      style: toggleStyle,
      spacing: 110,
      current: remindersON,
      first: false,
      second: true,
      onChanged: (b) => _toggled(b),
      iconBuilder: (b) => b
          ? const Icon(Icons.notifications_active, size: 60)
          : isNotSleepTime
              ? const Icon(Icons.notifications_off, size: 60)
              : const Icon(Icons.bedtime_sharp, size: 60),
      textBuilder: (b) => b
          ? ReminderONWidget(db: widget.db)
          : isNotSleepTime
              ? const ReminderOFFWidget()
              : const SleepingWidget(),
    );
  }
}

class ReminderOFFWidget extends StatelessWidget {
  const ReminderOFFWidget({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle subTextStyle =
        const TextStyle(fontSize: 25, fontWeight: FontWeight.w900);

    TextStyle styledTextStyle = const TextStyle(
        fontSize: 30, fontWeight: FontWeight.w900, color: Colors.red);

    return getStyledText("Reminders", "Off", "", subTextStyle, styledTextStyle);
  }
}

class SleepingWidget extends StatelessWidget {
  const SleepingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle subTextStyle =
        const TextStyle(fontSize: 20, fontWeight: FontWeight.w900);

    TextStyle styledTextStyle = const TextStyle(
        fontSize: 25, fontWeight: FontWeight.w900, color: Colors.purple);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getStyledText("Reminders", "Off", "", subTextStyle, styledTextStyle),
        Text("Sleep tight!", style: subTextStyle),
        Text("We won't disturb", style: subTextStyle)
      ],
    );
  }
}

class ReminderONWidget extends StatefulWidget {
  const ReminderONWidget({super.key, required this.db});

  final Database db;

  @override
  State<ReminderONWidget> createState() => _ReminderONWidgetState();
}

class _ReminderONWidgetState extends State<ReminderONWidget> {
  Future<List> _dbQuery(Database db) async =>
      [await db.calcReminderGap(), await db.calcMedianDrinkSize()];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: _dbQuery(widget.db),
        builder: (context, snapshot) {
          // The default state of this widget. Doesn't represent
          // any data. Just for show.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return textForReminder(200, 10);
          }

          if (snapshot.hasError) return Text(snapshot.error.toString());

          return textForReminder(snapshot.data![1], snapshot.data![0]);
        });
  }
}

Widget textForReminder(int volume, int reminderGap) {
  TextStyle subTextStyle =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  TextStyle styledTextStyle = const TextStyle(
      fontSize: 25, fontWeight: FontWeight.w900, color: Colors.green);

  return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Reminders set for", style: subTextStyle),
        getStyledText("", "$volume mL", "water", subTextStyle, styledTextStyle),
        getStyledText("every", getDurationInText(reminderGap), "", subTextStyle,
            styledTextStyle),
      ]);
}

String getDurationInText(int duration) {
  if (duration >= 60) return "${(duration / 60).toStringAsFixed(1)} hrs";

  return "$duration mins";
}
