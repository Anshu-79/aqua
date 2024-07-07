import 'package:flutter/material.dart';
import 'package:aqua/utils.dart' as utils;

String getGoalText(int vol) {
  double litres = vol / 1000;

  if (litres >= 100) return litres.toStringAsFixed(1);

  return litres.toStringAsFixed(2);
}

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

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _consumedVol = widget.consumedVol;

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: utils.BorderedText(
                  text: getGoalText(_consumedVol),
                  strokeWidth: 4,
                  textStyle: utils.ThemeText.dailyGoalConsumed),
            ),
            Text.rich(TextSpan(
                text: " L", style: utils.ThemeText.dailyGoalFillerText))
          ],
        ),
        Text("of", style: utils.ThemeText.dailyGoalFillerText),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          utils.BorderedText(
              text: getGoalText(widget.totalVol),
              strokeWidth: 4,
              textStyle: utils.ThemeText.dailyGoalTotal),
          Text.rich(
              TextSpan(text: " L", style: utils.ThemeText.dailyGoalFillerText)),
        ]),
      ],
    );
  }
}
