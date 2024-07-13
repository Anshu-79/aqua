import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';

import 'package:aqua/utils/colors.dart';
import 'package:aqua/permission_handlers.dart';

/// This Screen is displayed during the Onboarding Scroll
class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    requestLocationPermission();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Crab(
                  tag: 'graphic',
                  child: Image.asset("assets/images/reminder.gif"))),
          FittedBox(
            child: AnimatedTextKit(repeatForever: true, animatedTexts: [
              ColorizeAnimatedText("Friendly\nReminders",
                  textAlign: TextAlign.center,
                  colors: textColorizeColors,
                  speed: const Duration(milliseconds: 500),
                  textStyle:
                      const TextStyle(fontSize: 200, fontWeight: FontWeight.w900))
            ]),
          ),
          const SizedBox(height: 20),
          const Text(
            "Receive friendly reminders to take a sip and reach your water goals.\nWe'll make sure you stay on top of your hydration game.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.normal,
                color: Colors.grey),
          )
        ],
      ),
    );
  }
}
