import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils/colors.dart';
import 'package:aqua/utils/icomoon_icons.dart';
import 'package:aqua/screens/user_profile/stat_utils.dart';

/// Encapsulates the statistics section of the UserProfile page
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Wrap(runSpacing: 15, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          StatsSummary(
            color: AquaColors.red,
            stats: getStreak(widget.db),
            statsSubtext: "Day Streak",
            icondata: Icons.whatshot_sharp,
          ),
          const SizedBox(width: 30),
          StatsSummary(
              color: AquaColors.yellow,
              stats: getLongestStreak(widget.db),
              statsSubtext: "Longest Streak",
              icondata: Icons.emoji_events_sharp)
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          StatsSummary(
              color: AquaColors.blue,
              stats: getLastWeekWaterIntake(widget.db),
              statsSubtext: "Water this Week",
              icondata: Icomoon.water_bottle),
          const SizedBox(width: 30),
          StatsSummary(
              color: AquaColors.mint,
              stats: getTotalHydration(widget.db),
              statsSubtext: "Lifetime Intake",
              icondata: Icons.calendar_month_sharp)
        ]),
      ]),
    );
  }
}
