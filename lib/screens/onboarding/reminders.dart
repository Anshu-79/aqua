import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';

import 'package:aqua/utils.dart' as utils;
import 'package:aqua/permission_handlers.dart';

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
          AnimatedTextKit(repeatForever: true, animatedTexts: [
            ColorizeAnimatedText(
              "Friendly Reminders",
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
