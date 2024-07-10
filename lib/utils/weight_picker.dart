import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:aqua/utils.dart' as utils;

// Helper functions
int toLbs(int kg) => (kg * 2.20462).round();

int toKg(int lb) => (lb / 2.20462).round();

class WeightPicker extends StatefulWidget {
  const WeightPicker(
      {super.key,
      required this.weight,
      required this.notifyParent,
      required this.textSize});

  final int weight; // in kg
  final int textSize;
  final Function notifyParent;

  @override
  State<WeightPicker> createState() => _WeightPickerState();
}

class _WeightPickerState extends State<WeightPicker> {
  bool isMetric = true;
  late final Map<String, int> _weight = {'kg': widget.weight};

  @override
  void initState() {
    _weight['lb'] = toLbs(_weight['kg']!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isMetric ? weightPicker('kg', 10, 651) : weightPicker('lb', 22, 1435),
        const SizedBox(height: 20),
        unitsToggle()
      ],
    );
  }

  Widget weightPicker(String unit, int min, int max) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NumberPicker(
            infiniteLoop: true,
            itemHeight: widget.textSize + 10,
            itemWidth: widget.textSize * 2.5,
            textStyle: TextStyle(
                fontWeight: FontWeight.w900, fontSize: widget.textSize / 2),
            selectedTextStyle: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: widget.textSize.toDouble(),
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
                  widget.notifyParent(_weight['kg']);
                })),
        Text(
          unit,
          style: TextStyle(
              fontSize: widget.textSize / 2, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

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
          backgroundColor: Theme.of(context).canvasColor,
          indicatorColor: b
              ? utils.defaultColors['dark blue']
              : utils.defaultColors['red']),
      textBuilder: (value) => value
          ? const Center(child: Text('Metric'))
          : const Center(child: Text('Imperial')),
    );
  }
}
