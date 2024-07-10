import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';

import 'package:aqua/utils/widgets/universal_header.dart';
import 'package:aqua/database/database.dart';
import 'package:aqua/utils/colors.dart';

import 'package:aqua/screens/charts/bev_volume_bar_chart.dart';
import 'package:aqua/screens/charts/bev_distribution_pie_chart.dart';
import 'package:aqua/screens/charts/bev_trend_chart.dart';
import 'package:aqua/screens/charts/total_intake_chart.dart';
import 'package:aqua/screens/charts/workout_duration_pie_chart.dart';
import 'package:aqua/screens/charts/chart_model.dart';

enum DaysRangeLabel {
  week('Last week', 7),
  fortnight('Last 2 weeks', 14),
  month('Last month', 30),
  quarterYear('Last 3 months', 30 * 3),
  year('Last year', 365);

  const DaysRangeLabel(this.label, this.value);
  final String label;
  final int value;
}

// Parent widget to hold all the charts
class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key, required this.db});
  final Database db;

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  late Future<List<WaterGoal>> _waterGoals;
  late Future<Map<Beverage, Map>> _drinksData;
  late Future<Map<String, Map<Beverage, int>>> _daywiseDrinksData;
  late Future<Map<Beverage, int>> _totalBevDistribution;
  late Future<Map<Activity, int>> _workouts;

  bool showWater = true;
  DaysRangeLabel? selectedRange = DaysRangeLabel.week;
  final TextEditingController daysRangeController = TextEditingController();

  @override
  void initState() {
    _waterGoals = widget.db.getWaterGoals();
    _drinksData = widget.db.bevWiseDailyConsumption(selectedRange!.value);
    _daywiseDrinksData = widget.db.daywiseAllBevsConsumption();
    _totalBevDistribution = widget.db.totalVolumePerBeverage();
    _workouts = widget.db.totalDurationPerActivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget dayRangeDropdown() {
      return DropdownMenu<DaysRangeLabel>(
          inputDecorationTheme: InputDecorationTheme(
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
          initialSelection: DaysRangeLabel.week,
          width: 150,
          controller: daysRangeController,
          label: const Text('Data Range'),
          onSelected: (DaysRangeLabel? range) =>
              setState(() => selectedRange = range),
          dropdownMenuEntries: DaysRangeLabel.values
              .map<DropdownMenuEntry<DaysRangeLabel>>((DaysRangeLabel range) {
            return DropdownMenuEntry<DaysRangeLabel>(
              value: range,
              label: range.label,
              enabled: range.label != 'Grey',
            );
          }).toList());
    }

    Widget showWaterToggle() {
      return AnimatedToggleSwitch<bool>.dual(
          current: showWater,
          first: false,
          second: true,
          spacing: 20,
          borderWidth: 1.0,
          height: 55,
          onChanged: (b) => setState(() => showWater = b),
          styleBuilder: (b) => ToggleStyle(
            backgroundColor: Theme.of(context).canvasColor,
              indicatorColor:
                  b ? AquaColors.darkBlue : Colors.grey.shade300),
          textBuilder: (value) => const Text('Water',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)));
    }

    return Scaffold(
      appBar: const UniversalHeader(title: "Statistics"),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [dayRangeDropdown(), showWaterToggle()],
              ),
              GenericChart(
                headerText: 'Hydration Trend',
                dataFuture: _waterGoals,
                chartBuilder: (data) => TotalWaterTrendChart(
                    waterGoals: data, daysRange: selectedRange!.value),
              ),
              GenericChart(
                headerText: 'Beverage Intake Trend',
                dataFuture: _drinksData,
                chartBuilder: (data) => BeverageTrendChart(
                    drinks: data,
                    daysRange: selectedRange!.value,
                    showWater: showWater),
              ),
              GenericChart(
                headerText: 'Beverage Volume Breakdown',
                dataFuture: _daywiseDrinksData,
                chartBuilder: (data) => BevDistributionBarChart(
                  drinks: data,
                  showWater: showWater,
                  daysRange: selectedRange!.value,
                ),
              ),
              GenericChart(
                headerText: 'Net Beverage Breakdown',
                dataFuture: _totalBevDistribution,
                chartBuilder: (data) =>
                    BevsPieChart(bevMap: data, showWater: showWater),
              ),
              GenericChart(
                headerText: 'Workout Duration Breakdown',
                dataFuture: _workouts,
                chartBuilder: (data) => WorkoutDurationPieChart(workouts: data),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
