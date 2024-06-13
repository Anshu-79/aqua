import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';

import 'package:aqua/utils.dart' as utils;

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Crab(
          tag: 'logo',
          child: Image.asset("assets/images/progress.gif")),
          const SizedBox(height: 50,),
        AnimatedTextKit(repeatForever: true, animatedTexts: [
          ColorizeAnimatedText(
            "See Growth",
            textAlign: TextAlign.center,
            textStyle:
                const TextStyle(fontSize: 55, fontWeight: FontWeight.w900),
            colors: utils.textColorizeColors,
            speed: const Duration(milliseconds: 500),
          )
        ]),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Watch your progress unfold! Stay motivated and celebrate your achievements.",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.normal,
              color: Colors.grey),
        )
      ],
    );
  }
}
