import 'package:aqua/screens/user_profile/charts/bev_distribution_bar_chart.dart';
import 'package:aqua/screens/user_profile/charts/bev_distribution_pie_chart.dart';
import 'package:aqua/screens/user_profile/charts/bev_trend_chart.dart';
import 'package:aqua/screens/user_profile/charts/total_intake_chart.dart';
import 'package:aqua/screens/user_profile/charts/workout_duration_pie_chart.dart';
import 'package:flutter/material.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils.dart' as utils;

Beverage water = Beverage(
    id: 1,
    name: 'Water',
    colorCode: utils.defaultColors['blue']!.value.toRadixString(16),
    starred: true,
    waterPercent: 100);


// Parent widget to hold all the charts
class ChartsHolder extends StatefulWidget {
  const ChartsHolder({super.key, required this.db});
  final Database db;

  @override
  State<ChartsHolder> createState() => _ChartsHolderState();
}

class _ChartsHolderState extends State<ChartsHolder> {
  late Future<List<WaterGoal>> _waterGoals;
  late Future<Map<Beverage, Map>> _drinksData;
  late Future<Map<String, Map<Beverage, int>>> _daywiseDrinksData;
  late Future<Map<Beverage, int>> _totalBevDistribution;
  late Future<Map<Activity, int>> _workouts;

  @override
  void initState() {
    _waterGoals = widget.db.getWaterGoals();
    _drinksData = widget.db.bevWiseDailyConsumption();
    _daywiseDrinksData = widget.db.daywiseAllBevsConsumption();
    _totalBevDistribution = widget.db.totalVolumePerBeverage();
    _workouts = widget.db.totalDurationPerActivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GenericChart(
          headerText: 'Hydation Trend',
          dataFuture: _waterGoals,
          chartBuilder: (data) => TotalWaterTrendChart(waterGoals: data),
        ),
        GenericChart(
          headerText: 'Beverage Intake Trend',
          dataFuture: _drinksData,
          chartBuilder: (data) => BeverageTrendChart(drinks: data),
        ),
        GenericChart(
          headerText: 'Daily Beverage Breakdown',
          dataFuture: _daywiseDrinksData,
          chartBuilder: (data) => BevDistributionBarChart(drinks: data),
        ),
        GenericChart(
          headerText: 'Net Beverage Breakdown',
          dataFuture: _totalBevDistribution,
          chartBuilder: (data) => BevsPieChart(bevMap: data),
        ),
        GenericChart(
          headerText: 'Workout Duration Breakdown',
          dataFuture: _workouts,
          chartBuilder: (data) => WorkoutDurationPieChart(workouts: data),
        ),
      ],
    );
  }
}


// Displays a Progress Indicator while the chart loads
class GenericChart<T> extends StatelessWidget {
  const GenericChart({
    super.key,
    required this.headerText,
    required this.dataFuture,
    required this.chartBuilder,
  });

  final String headerText;
  final Future<T> dataFuture;
  final Widget Function(T) chartBuilder;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor.computeLuminance() > 0.5
            ? Colors.grey.shade200
            : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Theme.of(context).primaryColor, width: 5),
      ),
      child: FutureBuilder<T>(
          future: dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            return Column(
              children: [
                FittedBox(
                  fit: BoxFit.contain,
                  child: Text(headerText,
                      style: const TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 40)),
                ),
                const SizedBox(height: 20),
                AspectRatio(
                    aspectRatio: 2.0, child: chartBuilder(snapshot.data as T)),
              ],
            );
          }),
    );
  }
}
