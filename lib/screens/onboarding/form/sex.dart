import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';

import 'package:aqua/screens/onboarding/form/profile.dart';
import 'package:aqua/screens/onboarding/form/nav_buttons.dart';
import 'package:aqua/utils.dart' as utils;
import 'package:aqua/shape_painter.dart';

class SexInputScreen extends StatefulWidget {
  const SexInputScreen({super.key});

  @override
  State<SexInputScreen> createState() => _SexInputScreenState();
}

class _SexInputScreenState extends State<SexInputScreen> {
  String _selected = 'M';

  Widget sexRadioButton(String value, Color color, Icon icon) {
    bool isSelected = _selected == value;
    return SizedBox(
      height: 140,
      width: 140,
      child: IconButton(
        icon: icon,
        onPressed: () => setState(() => _selected = value),
        iconSize: 100,
        style: IconButton.styleFrom(
            backgroundColor: isSelected ? color : utils.lighten(color, 30),
            foregroundColor: Colors.white,
            side: BorderSide(
              color: color,
              width: 5,
            )),
      ),
    );
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
                    Container(
                      height: 200,
                      child: AnimatedTextKit(
                        totalRepeatCount: 1,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            "And what is your sex?",
                            textStyle: const TextStyle(
                                fontSize: 50, fontWeight: FontWeight.w800),
                            textAlign: TextAlign.center,
                            cursor: '|',
                            speed: const Duration(milliseconds: 100),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            sexRadioButton(
                                'M', Colors.blue, const Icon(Icons.male)),
                            sexRadioButton('F', Colors.pink.shade400,
                                const Icon(Icons.female)),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        sexRadioButton(
                            'O', Colors.purple, const Icon(Icons.transgender))
                      ],
                    ),
                  ]),
            ),
          ],
        ),
        bottomNavigationBar: NavButtons(navBack: () {
          context.flow<Profile>().update((profile) => profile.decrementPage());
        }, navForward: () {
          context.flow<Profile>().update(
              (profile) => profile.copyWith(sex: _selected).incrementPage());
        }));
  }
}
