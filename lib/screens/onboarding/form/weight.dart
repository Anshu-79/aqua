import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:aqua/screens/onboarding/form/profile.dart';
import 'package:aqua/screens/onboarding/form/nav_buttons.dart';
import 'package:aqua/shape_painter.dart';
import 'package:aqua/utils.dart' as utils;

class WeightInputScreen extends StatefulWidget {
  const WeightInputScreen({super.key});

  @override
  State<WeightInputScreen> createState() => _WeightInputScreenState();
}

class _WeightInputScreenState extends State<WeightInputScreen> {
  int _weight = 60;

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
                    const SizedBox(
                      height: 200,
                      child: utils.OnboardingQuestion(text: "How much do you weigh?",)
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
                              selectedTextStyle:  TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 100,
                                  color: utils.defaultColors['dark blue']),
                              haptics: true,
                              itemCount: 3,
                              minValue: 10,
                              maxValue: 650,
                              value: _weight,
                              onChanged: (val) =>
                                  setState(() => _weight = val)),
                          const Text(
                            "kg",
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
              (profile) => profile.copyWith(weight: _weight).incrementPage());
        }));
  }
}
