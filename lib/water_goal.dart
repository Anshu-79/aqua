import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:aqua/utils.dart' as utils;

class WaterGoalWidget extends StatefulWidget {
  const WaterGoalWidget({
    super.key,
    required this.child,
    required this.fillValue,
  });

  final Widget child;
  final double fillValue;

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
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: CustomPaint(
            painter: WaterPainter(
              firstAnimation.value,
              secondAnimation.value,
              thirdAnimation.value,
              fourthAnimation.value,
              widget.fillValue,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
        widget.child,
      ],
    );
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
    var paint = Paint()
      ..color = utils.defaultColors['blue']!.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    double waterHeight = size.height * (1 - fillValue);

    var path = Path()
      ..moveTo(0, waterHeight + 20 * sin(firstValue))
      ..cubicTo(
          size.width * 0.25,
          waterHeight + 20 * sin(secondValue + pi / 2),
          size.width * 0.75,
          waterHeight + 20 * sin(thirdValue + pi),
          size.width,
          waterHeight + 20 * sin(fourthValue + 3 * pi / 2))
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
