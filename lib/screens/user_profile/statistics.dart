import 'package:aqua/database/database.dart';
import 'package:aqua/screens/user_profile/charts.dart';
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
          stats: widget.prefs.getInt('streak')!.toString(),
          statsSubtext: "Day Streak",
          icondata: Icons.whatshot,
        ),
        StatsSummary(
            color: utils.defaultColors['blue']!,
            stats: "7.9 L",
            statsSubtext: "Water per Week",
            icondata: Icomoon.water_bottle)
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        StatsSummary(
            color: utils.defaultColors['mint']!,
            stats: "42 L",
            statsSubtext: "Lifetime Intake",
            icondata: Icons.calendar_month_sharp),
        StatsSummary(
            color: utils.defaultColors['yellow']!,
            stats: "10 L",
            statsSubtext: "Fluids per Week",
            icondata: Icomoon.iced_liquid)
      ]),
      ChartsHolder(db: widget.db),
    ]);
  }
}
