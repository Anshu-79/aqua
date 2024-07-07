import 'package:flutter/material.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils.dart' as utils;

class StatsSummary extends StatefulWidget {
  const StatsSummary(
      {super.key,
      required this.color,
      required this.stats,
      required this.statsSubtext,
      required this.icondata});

  final Color color;
  final IconData icondata;
  final Future<String> stats;
  final String statsSubtext;

  @override
  State<StatsSummary> createState() => StatsSummaryState();
}

class StatsSummaryState extends State<StatsSummary> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.stats,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        return Container(
            padding: const EdgeInsets.all(5),
            height: 65,
            width: 150,
            decoration: BoxDecoration(
                color: widget.color.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: widget.color, width: 3)),
            child: Row(children: [
              Icon(widget.icondata, size: 30, color: widget.color),
              const SizedBox(width: 10),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(snapshot.data!, style: utils.ThemeText.userStats),
                    Text(widget.statsSubtext,
                        style: utils.ThemeText.userStatsSubtext)
                  ])
            ]));
      },
    );
  }
}

Future<String> getStreak(Database db) async {
  List<WaterGoal> goals = await db.getWaterGoals();

  goals = goals.reversed.toList();

  List<int> dailyWaterDeficit = List.generate(goals.length, (i) {
    return goals[i].consumedVolume - goals[i].totalVolume;
  });

  if (dailyWaterDeficit.isEmpty) return "0";

  if (dailyWaterDeficit[0] < 0) dailyWaterDeficit.removeAt(0);
  // Remove today's entry if the goal hasn't been completed yet.
  // This allows the user to potentially complete the goal later.
  // Without removing it, the streak would always be 0 until the goal is met.

  int streak = 0;

  for (int i = 0; i < dailyWaterDeficit.length; i++) {
    if (dailyWaterDeficit[i] < 0) break;
    streak += 1;
  }

  return streak.toString();
}

