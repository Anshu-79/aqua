import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';

import 'package:aqua/screens/onboarding/form/profile.dart';
import 'package:aqua/utils/widgets/height_picker.dart';
import 'package:aqua/screens/onboarding/form/nav_buttons.dart';
import 'package:aqua/shape_painter.dart';
import 'package:aqua/utils/miscellaneous.dart' as utils;

class HeightInputScreen extends StatefulWidget {
  const HeightInputScreen({super.key});

  @override
  State<HeightInputScreen> createState() => _HeightInputScreenState();
}

class _HeightInputScreenState extends State<HeightInputScreen> {
  late int height;
  refresh(h) => setState(() => height = h);

  @override
  void initState() {
    height = 150;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Profile profile = context.flow<Profile>().state;
    height = profile.height ?? height;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            const ColoredShapesBackground(),
            Container(
              margin: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const utils.OnboardingQuestion(text: "How tall are you?"),
                    const SizedBox(height: 20),
                    HeightPicker(height: height, textSize: 75, notifyParent: refresh)
                  ]),
            ),
          ],
        ),
        bottomNavigationBar: NavButtons(navBack: () {
          context.flow<Profile>().update((profile) => profile.decrementPage());
        }, navForward: () {
          context.flow<Profile>().update((profile) =>
              profile.copyWith(height: height).incrementPage());
        }));
  }
}
