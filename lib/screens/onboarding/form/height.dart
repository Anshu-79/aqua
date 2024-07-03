import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:aqua/screens/onboarding/form/profile.dart';
import 'package:aqua/screens/onboarding/form/nav_buttons.dart';
import 'package:aqua/shape_painter.dart';
import 'package:aqua/utils.dart' as utils;

// Helper functions
int toCMs(int feet, int inches) {
  int cm = ((inches + feet * 12) * 2.54).toInt();
  if (cm < 61) return 61;
  return cm;
}

int toFeet(int height) => height * 0.3937008 ~/ 12;

int toInch(int height) =>
    ((height * 0.3937008 / 12 - toFeet(height)) * 12).toInt();

class HeightInputScreen extends StatefulWidget {
  const HeightInputScreen({super.key});

  @override
  State<HeightInputScreen> createState() => _HeightInputScreenState();
}

class _HeightInputScreenState extends State<HeightInputScreen> {
  final Map<String, int> _height = {'cm': 0, 'ft': 0, 'in': 0};
  bool isMetric = true;

  @override
  void initState() {
    super.initState();
    _height['cm'] = 150;
    _height['ft'] = toFeet(_height['cm']!);
    _height['in'] = toInch(_height['cm']!);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Profile profile = context.flow<Profile>().state;
    _height['cm'] = profile.height ?? _height['cm']!;
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

    Widget heightPicker(String unit, int min, int max) {
      double width = isMetric ? 150 : 120;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          NumberPicker(
              infiniteLoop: true,
              zeroPad: true,
              itemHeight: 100,
              itemWidth: width,
              textStyle:
                  const TextStyle(fontWeight: FontWeight.w900, fontSize: 35),
              selectedTextStyle: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 75,
                  color: utils.defaultColors['dark blue']),
              haptics: true,
              itemCount: 3,
              minValue: min,
              maxValue: max,
              value: _height[unit]!,
              onChanged: (val) => setState(() {
                    _height[unit] = val;

                    if (unit == 'cm') {
                      _height['ft'] = toFeet(val);
                      _height['in'] = toInch(val);
                    } else {
                      _height['cm'] = toCMs(_height['ft']!, _height['in']!);
                    }
                  })),
          Text(unit,
              style:
                  const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        ],
      );
    }

    Widget metricHeightPicker() => heightPicker('cm', 61, 272);

    Widget imperialHeightPicker() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [heightPicker('ft', 2, 8), heightPicker('in', 0, 11)],
        );

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
                    const utils.OnboardingQuestion(text: "How tall are you?"),
                    const SizedBox(height: 20),
                    isMetric ? metricHeightPicker() : imperialHeightPicker(),
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
              profile.copyWith(height: _height['cm']!).incrementPage());
        }));
  }
}
