import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils.dart' as utils;

class AquaGenericChart<T> extends StatelessWidget {
  const AquaGenericChart(
      {super.key, required this.dataFuture, required this.chartBuilder});

  final Future<List<T>> dataFuture;
  final Widget Function(List<T>) chartBuilder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<T>>(
        future: dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          return chartBuilder(snapshot.data!);
        });
  }
}

List<FlSpot> totalWaterDataPoints(List<WaterGoal> waterGoals) {
  return List.generate(14, (i) {
    return FlSpot(
        (i + 1).toDouble(), Random().nextInt(6000 - 2000 + 1).toDouble());
  });

  // return List.generate(waterGoals.length, (idx) {
  //   return FlSpot(
  //     (idx+1).toDouble(),
  //     waterGoals[idx].consumedVolume.toDouble(),
  //   );
  // });
}

class TotalWaterLineChart extends StatelessWidget {
  const TotalWaterLineChart({super.key, required this.waterGoals});

  final List<WaterGoal> waterGoals;

  @override
  Widget build(BuildContext context) {
    Gradient chartGradient = const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [Color(0xffcc208e), Color(0xff2575fc)]);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: AspectRatio(
        aspectRatio: 2.0,
        child: LineChart(
          duration: const Duration(milliseconds: 150),
          LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: totalWaterDataPoints(waterGoals),
                  barWidth: 5,
                  isCurved: true,
                  preventCurveOverShooting: true,
                  gradient: chartGradient,
                  dotData: const FlDotData(show: false),
                ),
              ],
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(
                show: true,
                rightTitles: AxisTitles(),
                leftTitles: AxisTitles(axisNameWidget: Text("Volume (in mL)")),
                bottomTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: true)),
                topTitles: AxisTitles(
                    axisNameWidget: Text("Total Water Consumption / Day"),
                    axisNameSize: 30),
              )),
        ),
      ),
    );
  }
}

List<LineChartBarData> beverageDataPoints(Map<Beverage, Map> drinks) {
  final List<Beverage> beverages = drinks.keys.toList();
  return List.generate(drinks.length, (i) {
    final Beverage bev = beverages[i];
    final Map bevData = drinks[bev]!;

    return LineChartBarData(
      color: utils.toColor(bev.colorCode),
      barWidth: 5,
      isCurved: true,
      preventCurveOverShooting: true,
      dotData: const FlDotData(show: false),
      spots: List.generate(bevData.length, (j) {
        final DateTime date = bevData.keys.toList()[j];
        final volume = bevData[date];
        return FlSpot((j+1).toDouble(), volume.toDouble());
      })
    );
  });
  // return List.generate(length, generator)
}

class BevConsumptionLineChart extends StatelessWidget {
  const BevConsumptionLineChart({super.key, required this.drinks});

  final List<dynamic> drinks;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: AspectRatio(
        aspectRatio: 2.0,
        child: LineChart(
          duration: const Duration(milliseconds: 150),
          LineChartData(
              lineBarsData: beverageDataPoints(drinks[0]),
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(
                show: true,
                rightTitles: AxisTitles(),
                leftTitles: AxisTitles(axisNameWidget: Text("Volume (in mL)")),
                bottomTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: true)),
                topTitles: AxisTitles(
                    axisNameWidget: Text("Beverage Consumption / Day"),
                    axisNameSize: 30),
              )),
        ),
      ),
    );
  }
}
