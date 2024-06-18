import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:aqua/screens/onboarding/form/profile.dart';
import 'package:aqua/screens/onboarding/form/nav_buttons.dart';
import 'package:aqua/shape_painter.dart';
import 'package:aqua/utils.dart' as utils;

class HeightInputScreen extends StatefulWidget {
  const HeightInputScreen({super.key});

  @override
  State<HeightInputScreen> createState() => _HeightInputScreenState();
}

class _HeightInputScreenState extends State<HeightInputScreen> {
  late int _height;

  @override
  void initState() {
    super.initState();
    _height = 150;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Profile profile = context.flow<Profile>().state;
    _height = profile.height ?? _height;
  }

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
                        child: utils.OnboardingQuestion(
                          text: "How tall are you?",
                        )),
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
                              selectedTextStyle: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 100,
                                  color: utils.defaultColors['dark blue']),
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
