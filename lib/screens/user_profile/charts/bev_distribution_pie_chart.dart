import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils.dart' as utils;

class BevsPieChart extends StatefulWidget {
  const BevsPieChart({super.key, required this.bevMap});

  final Map<Beverage, int> bevMap;

  @override
  State<BevsPieChart> createState() => _BevsPieChartState();
}

class _BevsPieChartState extends State<BevsPieChart> {
  int touchedIndex = -1;

  List<PieChartSectionData> bevPieSections(Map<Beverage, int> bevDataMap) {
    // bevDataMap.remove(water);
    return List.generate(bevDataMap.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 90.0 : 80.0;

      Beverage bev = bevDataMap.keys.toList()[i];
      Color color =
          utils.adjustColorContrast(utils.toColor(bev.colorCode), 1.5);

      double volPercentage =
          100 * bevDataMap[bev]! / bevDataMap.values.toList().sum;
      return PieChartSectionData(
        showTitle: isTouched,
        title: "\t${bev.name}: ${volPercentage.toStringAsFixed(2)}%",
        titleStyle: TextStyle(
            backgroundColor: Colors.black.withOpacity(0.3),
            fontWeight: FontWeight.w900,
            fontSize: fontSize,
            color: Colors.white),
        titlePositionPercentageOffset: 0,
        value: bevDataMap[bev]!.toDouble(),
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
