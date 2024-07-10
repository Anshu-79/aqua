import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils/colors.dart';

Beverage water = Beverage(
    id: 1,
    name: 'Water',
    colorCode: AquaColors.blue.toHexCode(),
    starred: true,
    waterPercent: 100);

class BeverageTrendChart extends StatelessWidget {
  const BeverageTrendChart(
      {super.key,
      required this.drinks,
      required this.daysRange,
      required this.showWater});

  final Map<Beverage, Map> drinks;
  final int daysRange;
  final bool showWater;

  List<LineChartBarData> beverageLines(Map<Beverage, Map> drinks) {
    final List<Beverage> beverages = drinks.keys.toList();
    if (!showWater) beverages.remove(water);

    // Generate a list of lines accounting all beverages
    return List.generate(beverages.length, (i) {
      final Beverage bev = beverages[i];
      final Map bevData = drinks[bev]!;
      List dataInRange = bevData.keys.toList().reversed.take(daysRange).toList();
      dataInRange = dataInRange.reversed.toList();
      final Color color = bev.colorCode.toColor();

      return LineChartBarData(
          color: color,
          barWidth: 5,
          isCurved: true,
          preventCurveOverShooting: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                  colors: [color.withOpacity(0.4), color.withOpacity(0.1)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          // Generate a list of spots specific to each beverage
          spots: List.generate(dataInRange.length, (j) {
            final DateTime date = dataInRange[j];
            final volume = bevData[date];
            return FlSpot((j + 1).toDouble(), volume.toDouble());
          }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      duration: const Duration(milliseconds: 150),
      LineChartData(
          borderData: FlBorderData(show: false),
          lineBarsData: beverageLines(drinks),
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
