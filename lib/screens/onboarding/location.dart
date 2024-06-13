import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';

import 'package:aqua/utils.dart' as utils;

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _translationController;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _translationAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 500), // Adjust the duration as needed
    );

    // Define the rotation animation
    _rotationAnimation = Tween(begin: 0.0, end: pi).animate(
        CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut));

    _translationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    // Define the position animation (from top to bottom)
    _translationAnimation = Tween<Offset>(
      begin: Offset.zero,
      end:
          const Offset(0.0, -1.0), // Adjust the end Offset for desired distance
    ).animate(
      CurvedAnimation(
        parent: _translationController,
        curve: Curves.easeIn, // Animation curve for position
      ),
    );

    _rotationController.forward().whenComplete(() {
      _translationController.forward();
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _translationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Crab(
            tag: 'graphic',
            child: AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: AnimatedBuilder(
                    animation: _translationController,
                    builder: (context, child) {
                      return FractionalTranslation(
                        translation: _translationAnimation.value,
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                          width: 75,
                          height: 75,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
        Image.asset(
          'assets/images/globe.gif',
        ),
        const SizedBox(
          height: 20,
        ),
        AnimatedTextKit(repeatForever: true, animatedTexts: [
          ColorizeAnimatedText(
            "Weather Sense",
            textStyle:
                const TextStyle(fontSize: 43, fontWeight: FontWeight.w900),
            colors: utils.textColorizeColors,
            speed: const Duration(milliseconds: 1000),
          )
        ]),
        const Text(
          "We customize your water goals based on local weather for accurate recommendations tailored to your environment.",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.normal, color: Colors.grey),
        )
      ],
    );
  }
}
