import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:aqua/screens/onboarding/form/profile.dart';
import 'package:aqua/screens/onboarding/form/nav_buttons.dart';
import 'package:aqua/shape_painter.dart';

class HeightInputScreen extends StatefulWidget {
  const HeightInputScreen({super.key});

  @override
  State<HeightInputScreen> createState() => _HeightInputScreenState();
}

class _HeightInputScreenState extends State<HeightInputScreen> {
  int _height = 150;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            ColoredShapesBackground(),
            Container(
              margin: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      child: AnimatedTextKit(
                        totalRepeatCount: 1,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            "How tall are you?",
                            textStyle: const TextStyle(
                                fontSize: 50, fontWeight: FontWeight.w800),
                            textAlign: TextAlign.center,
                            cursor: '|',
                            speed: const Duration(milliseconds: 100),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          NumberPicker(
                              infiniteLoop: true,
                              itemHeight: 120,
                              itemWidth: 200,
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 50),
                              selectedTextStyle: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 100,
                                  color: Color(0xFF0264e1)),
                              haptics: true,
                              itemCount: 3,
                              minValue: 50,
                              maxValue: 275,
                              value: _height,
                              onChanged: (val) =>
                                  setState(() => _height = val)),
                          const Text(
                            "cm",
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ]),
            ),
          ],
        ),
        bottomNavigationBar: NavButtons(navBack: () {
          context.flow<Profile>().update((profile) => profile.decrementPage());
        }, navForward: () {
          context.flow<Profile>().update(
              (profile) => profile.copyWith(height: _height).incrementPage());
        }));
  }
}
