import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:aqua/database/database.dart';

class TotalWaterTrendChart extends StatelessWidget {
  const TotalWaterTrendChart({super.key, required this.waterGoals, required this.daysRange});

  final List<WaterGoal> waterGoals;
  final int daysRange;

  List<FlSpot> totalWaterDataPoints(List<WaterGoal> waterGoals) {

    // Select the last 7, 14, etc number of days
    List dataInRange = waterGoals.reversed.take(daysRange).toList();
    dataInRange = dataInRange.reversed.toList();
    
    return List.generate(dataInRange.length, (idx) {
      return FlSpot(
        (idx + 1).toDouble(),
        dataInRange[idx].consumedVolume.toDouble(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    LineChartBarData lineData = LineChartBarData(
        spots: totalWaterDataPoints(waterGoals),
        barWidth: 5,
        isCurved: true,
        preventCurveOverShooting: true,
        dotData: const FlDotData(show: false),
        gradient: const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color(0xffcc208e), Color(0xff2575fc)]),
        belowBarData: BarAreaData(
            show: true,
            gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color(0x1fcc208e), Color(0xcc2575fc)])));

    return LineChart(
      duration: const Duration(milliseconds: 150),
      LineChartData(
          borderData: FlBorderData(show: false),
          lineBarsData: [lineData],
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(
            show: true,
            rightTitles: AxisTitles(),
            leftTitles: AxisTitles(axisNameWidget: Text("Volume (in mL)")),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            topTitles: AxisTitles(),
          )),
    );
  }
}
