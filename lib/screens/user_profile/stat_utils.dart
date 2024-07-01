import 'package:flutter/material.dart';
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
  final String stats;
  final String statsSubtext;

  @override
  State<StatsSummary> createState() => StatsSummaryState();
}

class StatsSummaryState extends State<StatsSummary> {
  @override
  Widget build(BuildContext context) {
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
                Text(widget.stats, style: utils.ThemeText.userStats),
                Text(widget.statsSubtext,
                    style: utils.ThemeText.userStatsSubtext)
              ])
        ]));
  }
}
