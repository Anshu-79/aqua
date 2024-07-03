import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils.dart' as utils;

Beverage water = Beverage(
    id: 1,
    name: 'Water',
    colorCode: utils.toHexString(utils.defaultColors['blue']!),
    starred: true,
    waterPercent: 100);

class BevDistributionBarChart extends StatefulWidget {
  const BevDistributionBarChart(
      {super.key,
      required this.drinks,
      required this.showWater,
      required this.daysRange});

  final Map<String, Map<Beverage, int>> drinks;
  final bool showWater;
  final int daysRange;

  @override
  State<BevDistributionBarChart> createState() =>
      _BevDistributionBarChartState();
}

class _BevDistributionBarChartState extends State<BevDistributionBarChart> {
  int touchedIndex = -1;

  List<BarChartGroupData> generateBarChartGroups(
      Map<String, Map<Beverage, int>> drinksData) {
    
    int daysRange = widget.daysRange;
    if (daysRange > 14) daysRange = 14;

    final List<String> dates = drinksData.keys.toList();

    // Reverse to get last daysRange days
    List<String> datesInRange = dates.reversed.take(daysRange).toList();

    // Reverse again to retain original order
    datesInRange = datesInRange.reversed.toList();

    return List.generate(datesInRange.length, (i) {
      final isTouched = i == touchedIndex;
      final width = isTouched ? 25.0 : 20.0;

      Map<Beverage, int> allBevsDataOnDate = drinksData[datesInRange[i]]!;

      List<Beverage> beverages = allBevsDataOnDate.keys.toList();
      if (!widget.showWater) beverages.remove(water);

      List<int> volumes = allBevsDataOnDate.values.toList();
      if (!widget.showWater) volumes.remove(allBevsDataOnDate[water]);

      return BarChartGroupData(x: i + 1, barRods: [
        BarChartRodData(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(width: 2, color: Colors.white),
            width: width,
            toY: volumes.sum.toDouble(),
            rodStackItems: List.generate(beverages.length, (j) {
              Beverage bev = beverages[j];

              int volume = volumes[j];

              // starting point is calculated by adding all previous volumes
              int prevVolume = (j >= 1) ? volumes.sublist(0, j).sum : 0;

              return BarChartRodStackItem(
                  prevVolume.toDouble(),
                  volume.toDouble() + prevVolume.toDouble(),
                  utils.toColor(bev.colorCode),
                  const BorderSide(color: Colors.white));
            })),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(BarChartData(
      borderData: FlBorderData(show: false),
      gridData: const FlGridData(show: false),
      barGroups: generateBarChartGroups(widget.drinks),
      titlesData: const FlTitlesData(
        show: true,
        rightTitles: AxisTitles(),
        leftTitles: AxisTitles(axisNameWidget: Text("Volume (in mL)")),
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        topTitles: AxisTitles(),
      ),
      barTouchData: BarTouchData(
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
    ));
  }
}
