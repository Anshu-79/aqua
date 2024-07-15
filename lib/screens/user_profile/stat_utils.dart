import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils/textstyles.dart';

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

        return Expanded(
          child: AspectRatio(
              aspectRatio: 2.31,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: widget.color, width: 3)),
                child: Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: FittedBox(child: Icon(widget.icondata, size: 50, color: widget.color)),
                  ),
                  Expanded(
                    child: FittedBox(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            AutoSizeText(snapshot.data!,
                                style: ProfileScreenStyles.userStats,
                                maxLines: 1),
                            AutoSizeText(widget.statsSubtext,
                                style: ProfileScreenStyles.userStatsSubtext,
                                maxLines: 1)
                          ]),
                    ),
                  )
                ]),
              )),
        );
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

Future<String> getLongestStreak(Database db) async {
  List<WaterGoal> goals = await db.getWaterGoals();

  List<int> dailyWaterDeficit = List.generate(goals.length, (i) {
    return goals[i].consumedVolume - goals[i].totalVolume;
  });
  if (dailyWaterDeficit.isEmpty) return "0";

  int longestStreak = 0, streak = 0;
  for (final deficit in dailyWaterDeficit) {
    if (deficit >= 0) streak += 1;

    if (streak > longestStreak) longestStreak = streak;

    if (deficit < 0) streak = 0;
  }

  return longestStreak.toString();
}

Future<String> getTotalHydration(Database db) async {
  List<WaterGoal> goals = await db.getWaterGoals();

  if (goals.isEmpty) return "0 L";

  int totalConsumedVol =
      goals.fold(0, (sum, goal) => sum + goal.consumedVolume);

  // Convert to Litres
  double totalLitres = totalConsumedVol / 1000;

  if (totalLitres > 1000) {
    return "${(totalLitres / 1000).toStringAsFixed(1)} kL";
  }

  return "${totalLitres.toStringAsFixed(1)} L";
}

Future<String> getLastWeekWaterIntake(Database db) async {
  List<Drink> drinks = await db.getWaterDrinks();

  drinks = drinks.reversed.toList();
  // Reverse list for better performance

  DateTime now = DateTime.now();

  int daysToSubtract = now.weekday - DateTime.monday;
  if (daysToSubtract < 0) daysToSubtract += 7;

  DateTime lastMonday = now.subtract(Duration(days: daysToSubtract));

  lastMonday = DateTime(lastMonday.year, lastMonday.month, lastMonday.day);

  int waterIntakeLastWeek = 0;

  for (final drink in drinks) {
    if (drink.datetime.isBefore(lastMonday)) break;
    waterIntakeLastWeek += drink.volume;
  }

  // Convert to Litres
  double totalLitres = waterIntakeLastWeek / 1000;

  if (totalLitres > 1000) {
    return "${(totalLitres / 1000).toStringAsFixed(1)} kL";
  }

  return "${totalLitres.toStringAsFixed(1)} L";
}
