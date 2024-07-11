import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';

import 'package:aqua/utils/widgets/weight_picker.dart';
import 'package:aqua/screens/onboarding/form/profile.dart';
import 'package:aqua/screens/onboarding/form/nav_buttons.dart';
import 'package:aqua/shape_painter.dart';
import 'package:aqua/utils/miscellaneous.dart' as utils;

/// The [WeightInputScreen] uses the [WeightPicker] widget for height entry
class WeightInputScreen extends StatefulWidget {
  const WeightInputScreen({super.key});

  @override
  State<WeightInputScreen> createState() => _WeightInputScreenState();
}

class _WeightInputScreenState extends State<WeightInputScreen> {
  late int weight;
  refresh(w) => setState(() => weight = w);

  @override
  void initState() {
    weight = 60;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final Profile profile = context.flow<Profile>().state;
    weight = profile.weight ?? weight;
    super.didChangeDependencies();
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
                    const utils.OnboardingQuestion(
                        text: "How much do you weigh?"),
                    WeightPicker(
                        weight: weight, textSize: 100, notifyParent: refresh)
                  ]),
            ),
          ],
        ),
        bottomNavigationBar: NavButtons(navBack: () {
          context.flow<Profile>().update((profile) => profile.decrementPage());
        }, navForward: () {
          context.flow<Profile>().update(
              (profile) => profile.copyWith(weight: weight).incrementPage());
        }));
  }
}
