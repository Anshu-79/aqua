import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:aqua/screens/onboarding/form/profile.dart';
import 'package:aqua/screens/onboarding/form/nav_buttons.dart';
import 'package:aqua/shape_painter.dart';
import 'package:aqua/utils.dart' as utils;

int toLbs(int kg) {
  int lbs = (kg * 2.20462).toInt();
  if (lbs < 22) return 22;
  return lbs;
}

int toKg(int lb) {
  int kgs = (lb / 2.20462).toInt();
  if (kgs < 10) return 10;
  return kgs;
}

class WeightInputScreen extends StatefulWidget {
  const WeightInputScreen({super.key});

  @override
  State<WeightInputScreen> createState() => _WeightInputScreenState();
}

class _WeightInputScreenState extends State<WeightInputScreen> {
  final Map<String, int> _weight = {'kg': 0, 'lb': 0};
  bool isMetric = true;

  @override
  void initState() {
    _weight['kg'] = 60;
    _weight['lb'] = toLbs(_weight['kg']!);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final Profile profile = context.flow<Profile>().state;
    _weight['kg'] = profile.weight ?? _weight['kg']!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Widget unitsToggle() {
      return AnimatedToggleSwitch<bool>.dual(
        current: isMetric,
        first: false,
        second: true,
        spacing: 25.0,
        style: ToggleStyle(borderColor: Theme.of(context).primaryColor),
        borderWidth: 3.0,
        height: 50,
        onChanged: (b) => setState(() => isMetric = b),
        styleBuilder: (b) => ToggleStyle(
            indicatorColor: b
                ? utils.defaultColors['dark blue']
                : utils.defaultColors['red']),
        textBuilder: (value) => value
            ? const Center(child: Text('Metric'))
            : const Center(child: Text('Imperial')),
      );
    }

    Widget weightPicker(String unit, int min, int max) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NumberPicker(
              infiniteLoop: true,
              itemHeight: 120,
              itemWidth: 250,
              textStyle:
                  const TextStyle(fontWeight: FontWeight.w900, fontSize: 50),
              selectedTextStyle: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 100,
                  color: utils.defaultColors['dark blue']),
              haptics: true,
              itemCount: 3,
              minValue: min,
              maxValue: max,
              value: _weight[unit]!,
              onChanged: (val) => setState(() {
                    _weight[unit] = val;
                    if (unit == 'kg') {
                      _weight['lb'] = toLbs(val);
                    } else if (unit == 'lb') {
                      _weight['kg'] = toKg(val);
                    }
                  })),
          Text(
            unit,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }

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
                    const utils.OnboardingQuestion(
                        text: "How much do you weigh?"),
                    isMetric
                        ? weightPicker('kg', 10, 650)
                        : weightPicker('lb', 22, 1435),
                    const SizedBox(height: 20),
                    unitsToggle(),
                  ]),
            ),
          ],
        ),
        bottomNavigationBar: NavButtons(navBack: () {
          context.flow<Profile>().update((profile) => profile.decrementPage());
        }, navForward: () {
          context.flow<Profile>().update((profile) =>
              profile.copyWith(weight: _weight['kg']).incrementPage());
        }));
  }
}
