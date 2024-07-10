import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:aqua/utils/colors.dart';
import 'package:aqua/database/database.dart';

Beverage water = Beverage(
    id: 1,
    name: 'Water',
    colorCode: AquaColors.blue.toHexCode(),
    starred: true,
    waterPercent: 100);

class BevsPieChart extends StatefulWidget {
  const BevsPieChart(
      {super.key, required this.bevMap, required this.showWater});

  final Map<Beverage, int> bevMap;
  final bool showWater;

  @override
  State<BevsPieChart> createState() => _BevsPieChartState();
}

class _BevsPieChartState extends State<BevsPieChart> {
  int touchedIndex = -1;

  List<PieChartSectionData> bevPieSections(Map<Beverage, int> bevMap) {
    List<Beverage> beverages = bevMap.keys.toList();
    if (!widget.showWater) beverages.remove(water);

    return List.generate(beverages.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 90.0 : 80.0;

      Beverage bev = beverages[i];
      Color color = bev.colorCode.toColor();

      double volPercentage = 100 * bevMap[bev]! / bevMap.values.toList().sum;
      return PieChartSectionData(
        showTitle: isTouched,
        title: "\t${bev.name}: ${volPercentage.toStringAsFixed(2)}%",
        titleStyle: TextStyle(
            backgroundColor: Colors.black.withOpacity(0.3),
            fontWeight: FontWeight.w900,
            fontSize: fontSize,
            color: Colors.white),
        titlePositionPercentageOffset: 0,
        value: bevMap[bev]!.toDouble(),
        color: color,
        radius: radius,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PieChart(PieChartData(
      centerSpaceRadius: 0,
      startDegreeOffset: 70,
      borderData: FlBorderData(show: false),
      sections: bevPieSections(widget.bevMap),
      pieTouchData: PieTouchData(
        touchCallback: (FlTouchEvent event, pieTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                pieTouchResponse == null ||
                pieTouchResponse.touchedSection == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
          });
        },
      ),
    ));
  }
}
