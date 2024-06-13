import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';

import 'package:aqua/utils.dart' as utils;

class CongratsScreen extends StatelessWidget {
  const CongratsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Crab(tag: 'graphic',
        child: Image.asset("assets/images/congrats.gif")),
        AnimatedTextKit(repeatForever: true, animatedTexts: [
          ColorizeAnimatedText(
            "Congrats!",
            textAlign: TextAlign.center,
            textStyle:
                const TextStyle(fontSize: 65, fontWeight: FontWeight.w900),
            colors: utils.textColorizeColors,
            speed: const Duration(milliseconds: 500),
          )
        ]),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "You're now ready to embark on a journey towards better health and well-being.",
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
