import 'package:aqua/database/database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/screens/user_profile/stat_utils.dart';
import 'package:aqua/utils.dart' as utils;
import 'package:aqua/icomoon_icons.dart';

class StatsWidget extends StatefulWidget {
  const StatsWidget({super.key, required this.prefs, required this.db});
  final SharedPreferences prefs;
  final Database db;

  @override
  State<StatsWidget> createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {
  @override
  Widget build(BuildContext context) {
    return Wrap(runSpacing: 20, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        StatsSummary(
          color: utils.defaultColors['red']!,
          stats: getStreak(widget.db),
          statsSubtext: "Day Streak",
          icondata: Icons.whatshot_sharp,
        ),
        StatsSummary(
            color: utils.defaultColors['yellow']!,
            stats: getLongestStreak(widget.db),
            statsSubtext: "Longest Streak",
            icondata: Icons.emoji_events_sharp)
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        StatsSummary(
            color: utils.defaultColors['blue']!,
            stats: getLastWeekWaterIntake(widget.db),
            statsSubtext: "Water this Week",
            icondata: Icomoon.water_bottle),
        StatsSummary(
            color: utils.defaultColors['mint']!,
            stats: getTotalHydration(widget.db),
            statsSubtext: "Lifetime Intake",
            icondata: Icons.calendar_month_sharp)
      ]),
    ]);
  }
}
