import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';

import 'package:aqua/utils.dart' as utils;

class GoalScreen extends StatelessWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Crab(tag: 'img', child: Image.asset("assets/images/pick_glass.gif")),
        AnimatedTextKit(repeatForever: true, animatedTexts: [
          ColorizeAnimatedText(
            "Personalized Goals",
            textAlign: TextAlign.center,
            textStyle:
                const TextStyle(fontSize: 50, fontWeight: FontWeight.w900),
            colors: utils.textColorizeColors,
            speed: const Duration(milliseconds: 500),
          )
        ]),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Everyone's hydration needs are unique. Tell us about yourself, and we'll create a personalized water intake goal for you.",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.normal, color: Colors.grey),
        )
      ],
    );
  }
}
