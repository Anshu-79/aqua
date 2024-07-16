import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:aqua/utils/textstyles.dart' show HomeScreenStyles;
import 'package:aqua/utils/miscellaneous.dart' as utils;

String getGoalText(int vol) {
  double litres = vol / 1000;

  if (litres >= 100) return litres.toStringAsFixed(1);

  return litres.toStringAsFixed(2);
}

/// Renders the foreground of the Water Goal widget
/// Uses a fade animation to transition to updated values
/// when a callback from the FABs is received
class WaterGoalForeground extends StatefulWidget {
  const WaterGoalForeground(
      {super.key, required this.consumedVol, required this.totalVol});

  final int consumedVol;
  final int totalVol;

  @override
  State<WaterGoalForeground> createState() => WaterGoalForegroundState();
}

class WaterGoalForegroundState extends State<WaterGoalForeground>
    with SingleTickerProviderStateMixin {
  late int _consumedVol;
  late int _totalVol;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _consumedVol = widget.consumedVol;
    _totalVol = widget.totalVol;

    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void startFadeAnimation(double consumedVol) {
    setState(() {
      _consumedVol += consumedVol.toInt();

      _fadeAnimation =
          Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
      _fadeController
        ..reset()
        ..forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    utils.BorderedText(
                        text: getGoalText(_consumedVol),
                        textStyle: HomeScreenStyles.goal),
                    AutoSizeText(" L", style: HomeScreenStyles.goalSubtext)
                  ],
                ),
                AutoSizeText("of", style: HomeScreenStyles.goalSubtext),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  utils.BorderedText(
                      text: getGoalText(_totalVol),
                      textStyle: HomeScreenStyles.goal),
                  AutoSizeText(" L", style: HomeScreenStyles.goalSubtext),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
