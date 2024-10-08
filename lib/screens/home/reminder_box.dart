import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils/notifications.dart';
import 'package:aqua/utils/miscellaneous.dart' as utils;

bool isSleepTime(SharedPreferences prefs) {
  int sleepTime = prefs.getInt('sleepTime') ?? 0;
  int wakeTime = prefs.getInt('wakeTime') ?? 8;

  int nowHr = DateTime.now().hour;

  return utils.isHourBetween(nowHr, sleepTime, wakeTime);
}

Future<bool> isGoalCompleted(Database db) async {
  WaterGoal? goal = await db.getGoal(DateTime.now());
  int consumed = goal!.consumedVolume;
  int total = goal.totalVolume;
  return consumed >= total;
}

/// The [ReminderBox] is built on top of an [AnimatedToggleSwitch.dual]
/// It has 4 different states: ON, OFF, COMPLETE & SLEEP.
/// When set to ON, it displays the median drink size & reminder gap, indicating to the user the frequency of upcoming reminders
/// When set to OFF, it turns off all upcoming reminders
/// When set to SLEEP, no reminders are sent
/// When set to COMPLETE, reminders are sent next day
/// The user can turn the Switch ON or OFF, but it will automatically retain
/// the SLEEP state when [isSleepTime] turns true
/// A similar behaviour is observed for the COMPLETE state
class ReminderBox extends StatefulWidget {
  const ReminderBox(
      {super.key,
      required this.prefs,
      required this.db,
      required this.isGoalCompleted});
  final SharedPreferences prefs;
  final Database db;
  final bool isGoalCompleted;

  @override
  State<ReminderBox> createState() => _ReminderBoxState();
}

class _ReminderBoxState extends State<ReminderBox> {
  late bool remindersON;
  late bool isNotSleepTime;
  late bool isGoalCompleted;

  @override
  void initState() {
    isNotSleepTime = !isSleepTime(widget.prefs);

    if (!isNotSleepTime) NotificationsController.shiftNotificationsIfSleeping();

    remindersON = _getBoxState() == "ON";
    super.initState();
  }

  String _getBoxState() {
    bool userReminderPref = widget.prefs.getBool('reminders') ?? true;

    if (!isNotSleepTime) return "SLEEP";
    if (widget.isGoalCompleted) return "COMPLETE";
    if (userReminderPref) {
      return "ON";
    } else {
      return "OFF";
    }
  }

  void _toggled(bool b) async {
    setState(() => remindersON = b);
    widget.prefs.setBool('reminders', b);
    if (b) {
      NotificationsController.createHydrationNotification(
          await widget.db.getStoredReminderGap(),
          await widget.db.calcMedianDrinkSize());
    } else {
      NotificationsController.cancelScheduledNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color canvasColor = Theme.of(context).canvasColor;
    final double screenWidth = MediaQuery.of(context).size.width;

    ToggleStyle toggleStyle = ToggleStyle(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        backgroundColor: canvasColor,
        borderColor: primaryColor,
        indicatorBorderRadius: const BorderRadius.all(Radius.circular(20)),
        indicatorColor: indicatorColorMap[_getBoxState()]);
    return Expanded(
      child: AspectRatio(
        aspectRatio: 2.5,
        child: AnimatedToggleSwitch.dual(
          inactiveOpacity: 0.9,
          fittingMode: FittingMode.none,
          active: !isSleepTime(widget.prefs) && !(widget.isGoalCompleted),
          indicatorSize: Size.fromWidth(screenWidth / 3.6),
          borderWidth: 4,
          style: toggleStyle,
          current: remindersON,
          first: false,
          second: true,
          onChanged: (b) => _toggled(b),
          iconBuilder: (b) => Icon(indicatorIconMap[_getBoxState()],
              size: 60, color: Colors.white),
          textBuilder: (b) =>
              getBoxWidget(widget.db, widget.prefs, _getBoxState()),
        ),
      ),
    );
  }
}

Map<String, Color> indicatorColorMap = {
  "ON": Colors.green,
  "OFF": Colors.red,
  "SLEEP": Colors.purple,
  "COMPLETE": Colors.yellow.shade800,
};

Map<String, IconData> indicatorIconMap = {
  "ON": Icons.notifications_active,
  "OFF": Icons.notifications_off,
  "SLEEP": Icons.bedtime_sharp,
  "COMPLETE": Icons.emoji_events_sharp
};

Widget getBoxWidget(Database db, SharedPreferences prefs, String boxState) {
  Map<String, Widget> boxWidgetMap = {
    "ON": ReminderONWidget(db: db),
    "OFF": const ReminderOFFWidget(),
    "SLEEP": const SleepingWidget(),
    "COMPLETE": GoalCompletedWidget(prefs: prefs),
  };

  return boxWidgetMap[boxState]!;
}

/// A hacky solution to get a line of text with 2 different styles
Widget getStyledText(String prefix, String styledText, String suffix,
    TextStyle subTextStyle, TextStyle styledTextStyle,
    [AutoSizeGroup? group]) {
  return AutoSizeText.rich(
    maxLines: 1,
    style: const TextStyle(fontSize: 200),
    TextSpan(
      children: <TextSpan>[
        TextSpan(text: '$prefix ', style: subTextStyle),
        TextSpan(text: styledText, style: styledTextStyle),
        TextSpan(text: ' $suffix', style: subTextStyle),
      ],
    ),
  );
}

class GoalCompletedWidget extends StatelessWidget {
  const GoalCompletedWidget({super.key, required this.prefs});
  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    final int wakeTime = prefs.getInt('wakeTime') ?? 8;

    TextStyle subTextStyle = const TextStyle(fontWeight: FontWeight.w900);

    TextStyle styledTextStyle =
        TextStyle(fontWeight: FontWeight.w900, color: Colors.yellow.shade800);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Goal achieved!", style: subTextStyle),
        Text("See you later", style: subTextStyle),
        getStyledText("at", utils.getTimeInText(wakeTime), "", subTextStyle,
            styledTextStyle)
      ],
    );
  }
}

class ReminderOFFWidget extends StatelessWidget {
  const ReminderOFFWidget({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle subTextStyle = const TextStyle(fontWeight: FontWeight.w900);

    TextStyle styledTextStyle =
        const TextStyle(fontWeight: FontWeight.w900, color: Colors.red);

    return getStyledText("Reminders", "Off", "", subTextStyle, styledTextStyle);
  }
}

class SleepingWidget extends StatelessWidget {
  const SleepingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle subTextStyle = const TextStyle(fontWeight: FontWeight.w900);

    TextStyle styledTextStyle =
        const TextStyle(fontWeight: FontWeight.w900, color: Colors.purple);

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
      [await db.getStoredReminderGap(), await db.calcMedianDrinkSize()];

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
  TextStyle subTextStyle = const TextStyle(fontWeight: FontWeight.bold);

  TextStyle styledTextStyle =
      const TextStyle(fontWeight: FontWeight.w900, color: Colors.green);

  return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AutoSizeText("Reminders set for", style: subTextStyle, maxLines: 1),
        getStyledText("", "$volume mL", "water", subTextStyle, styledTextStyle),
        getStyledText("every", getDurationInText(reminderGap), "", subTextStyle,
            styledTextStyle),
      ]);
}

String getDurationInText(int duration) {
  if (duration >= 60) return "${(duration / 60).toStringAsFixed(1)} hrs";

  return "$duration mins";
}
