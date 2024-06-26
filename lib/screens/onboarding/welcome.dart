import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';

import 'package:aqua/utils.dart' as utils;

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: utils.defaultColors['dark blue']!, width: 5),
          ),
          height: 90,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Crab(
              tag: 'graphic',
              child: Image.asset(
                'assets/images/icon.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        AnimatedTextKit(repeatForever: true, animatedTexts: [
          ColorizeAnimatedText(
            "AQUA",
            textStyle:
                const TextStyle(fontSize: 115, fontWeight: FontWeight.w900),
            colors: utils.textColorizeColors,
            speed: const Duration(milliseconds: 1000),
          )
        ]),
        const SizedBox(
          height: 40,
        ),
        const Text(
          "Welcome to Aqua! We're here to help you prioritize your health by staying hydrated. Let's get started!",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.normal, color: Colors.grey),
        )
      ],
    );
  }
}
