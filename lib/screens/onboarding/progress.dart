import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';

import 'package:aqua/utils/colors.dart';
import 'package:aqua/permission_handlers.dart';

/// This Screen is displayed during the Onboarding Scroll
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    requestNotificationPermission();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Crab(tag: 'graphic', child: Image.asset("assets/images/progress.gif")),
        const SizedBox(height: 50),
        AnimatedTextKit(repeatForever: true, animatedTexts: [
          ColorizeAnimatedText("See Growth",
              textAlign: TextAlign.center,
              colors: textColorizeColors,
              speed: const Duration(milliseconds: 500),
              textStyle:
                  const TextStyle(fontSize: 55, fontWeight: FontWeight.w900))
        ]),
        const SizedBox(height: 20),
        const Text(
          "Watch your progress unfold! Stay motivated and celebrate your achievements.",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.normal, color: Colors.grey),
        )
      ],
    );
  }
}
