import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:aqua/utils.dart' as utils;

String getGoalText(int vol) => (vol / 1000).toStringAsFixed(2);

class WaterGoalWidget extends StatefulWidget {
  const WaterGoalWidget({
    super.key,
    required this.consumedVol,
    required this.totalVol,
  });

  final int consumedVol;
  final int totalVol;

  @override
  State<WaterGoalWidget> createState() => _WaterGoalWidgetState();
}

class _WaterGoalWidgetState extends State<WaterGoalWidget>
    with TickerProviderStateMixin {
  late AnimationController firstController;
  late Animation firstAnimation;

  late AnimationController secondController;
  late Animation secondAnimation;

  late AnimationController thirdController;
  late Animation thirdAnimation;

  late AnimationController fourthController;
  late Animation fourthAnimation;

  @override
  void initState() {
    super.initState();

    const duration = Duration(milliseconds: 3000);

    firstController = AnimationController(vsync: this, duration: duration);
    secondController = AnimationController(vsync: this, duration: duration);
    thirdController = AnimationController(vsync: this, duration: duration);
    fourthController = AnimationController(vsync: this, duration: duration);

    firstAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
        CurvedAnimation(parent: firstController, curve: Curves.easeInOut))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          firstController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          if (mounted) firstController.forward();
        }
      });

    secondAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
        CurvedAnimation(parent: secondController, curve: Curves.easeInOut))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          secondController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          if (mounted) secondController.forward();
        }
      });

    thirdAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
        CurvedAnimation(parent: thirdController, curve: Curves.easeInOut))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          thirdController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          if (mounted) thirdController.forward();
        }
      });

    fourthAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
        CurvedAnimation(parent: fourthController, curve: Curves.easeInOut))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          fourthController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          if (mounted) fourthController.forward();
        }
      });

    firstController.addListener(_updateState);
    secondController.addListener(_updateState);
    thirdController.addListener(_updateState);
    fourthController.addListener(_updateState);

    Timer(const Duration(milliseconds: 2000), () {
      if (mounted) firstController.forward();
    });

    Timer(const Duration(milliseconds: 1600), () {
      if (mounted) secondController.forward();
    });

    Timer(const Duration(milliseconds: 800), () {
      if (mounted) thirdController.forward();
    });

    if (mounted) fourthController.forward();
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    firstController.removeListener(_updateState);
    secondController.removeListener(_updateState);
    thirdController.removeListener(_updateState);
    fourthController.removeListener(_updateState);

    firstController.dispose();
    secondController.dispose();
    thirdController.dispose();
    fourthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 425,
      decoration: BoxDecoration(
          border: Border.all(width: 4, color: Theme.of(context).primaryColor),
          borderRadius: const BorderRadius.all(Radius.circular(50))),
      child: Stack(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(45),
              child: CustomPaint(
                painter: WaterPainter(
                    firstAnimation.value,
                    secondAnimation.value,
                    thirdAnimation.value,
                    fourthAnimation.value,
                    widget.consumedVol / widget.totalVol),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width),
              )),
          WaterGoalForeground(
              consumedVol: widget.consumedVol, totalVol: widget.totalVol),
        ],
      ),
    );
  }
}

class WaterGoalForeground extends StatefulWidget {
  const WaterGoalForeground(
      {super.key, required this.consumedVol, required this.totalVol});

  final int consumedVol;
  final int totalVol;

  @override
  State<WaterGoalForeground> createState() => _WaterGoalForegroundState();
}

class _WaterGoalForegroundState extends State<WaterGoalForeground> {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          utils.BorderedText(
              text: getGoalText(widget.consumedVol),
              textStyle: utils.ThemeText.dailyGoalConsumed),
          Text.rich(
              TextSpan(text: " L", style: utils.ThemeText.dailyGoalFillerText))
        ],
      ),
      Text("of", style: utils.ThemeText.dailyGoalFillerText),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        utils.BorderedText(
            text: getGoalText(widget.totalVol),
            textStyle: utils.ThemeText.dailyGoalTotal),
        Text.rich(
            TextSpan(text: " L", style: utils.ThemeText.dailyGoalFillerText)),
      ]),
      Text("consumed", style: utils.ThemeText.dailyGoalFillerText)
    ]);
  }
}

class WaterPainter extends CustomPainter {
  final double firstValue;
  final double secondValue;
  final double thirdValue;
  final double fourthValue;
  final double fillValue;

  WaterPainter(this.firstValue, this.secondValue, this.thirdValue,
      this.fourthValue, this.fillValue);

  @override
  void paint(Canvas canvas, Size size) {
    double waterHeight = size.height * (1 - fillValue);

    var gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        utils.lighten(utils.defaultColors['dark blue']!, 50),
        utils.defaultColors['dark blue']!
      ],
    );

    var rect =
        Rect.fromLTWH(0, waterHeight, size.width, size.height - waterHeight);
    var paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    var path = Path()
      ..moveTo(0, waterHeight + 10 * sin(firstValue))
      ..cubicTo(
          size.width * 0.25,
          waterHeight + 10 * sin(secondValue + pi / 2),
          size.width * 0.75,
          waterHeight + 10 * sin(thirdValue + pi),
          size.width,
          waterHeight + 10 * sin(fourthValue + 3 * pi / 2))
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
