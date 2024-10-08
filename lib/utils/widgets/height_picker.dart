import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:aqua/utils/colors.dart';

// Helper functions
int toCMs(int feet, int inches) {
  int cm = ((inches + feet * 12) * 2.54).toInt();
  if (cm < 61) return 61;
  return cm;
}

int toFeet(int height) => height * 0.3937008 ~/ 12;

int toInch(int height) =>
    ((height * 0.3937008 / 12 - toFeet(height)) * 12).toInt();

/// The [HeightPicker] widget consists of a [NumberPicker] & an [AnimatedToggleSwitch.dual]
/// The toggle offers functionality to switch between metric & imperial systems
class HeightPicker extends StatefulWidget {
  const HeightPicker(
      {super.key,
      required this.height,
      required this.notifyParent,
      required this.textSize});

  final int height; // in cm
  final int textSize;
  final Function notifyParent;

  @override
  State<HeightPicker> createState() => _HeightPickerState();
}

class _HeightPickerState extends State<HeightPicker> {
  bool isMetric = false; // this bool is contolled by metricToggle
  late final Map<String, int> _height = {'cm': widget.height};

  @override
  void initState() {
    super.initState();
    _height['cm'] = widget.height;
    _height['ft'] = toFeet(_height['cm']!);
    _height['in'] = toInch(_height['cm']!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      isMetric ? metricHeightPicker() : imperialHeightPicker(),
      const SizedBox(height: 20),
      metricToggle(),
    ]);
  }

  Widget metricToggle() {
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
          indicatorColor: b ? AquaColors.darkBlue : AquaColors.red),
      textBuilder: (value) => value
          ? const Center(child: Text('Metric'))
          : const Center(child: Text('Imperial')),
    );
  }

  Widget heightPicker(String unit, int min, int max) {
    double width = isMetric ? widget.textSize * 2 : widget.textSize * 2 - 20;

    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      NumberPicker(
          infiniteLoop: true,
          zeroPad: true,
          itemHeight: widget.textSize + 25,
          itemWidth: width,
          textStyle: TextStyle(
              fontWeight: FontWeight.w900, fontSize: widget.textSize / 2),
          selectedTextStyle: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: widget.textSize.toDouble(),
              color: AquaColors.darkBlue),
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
                widget.notifyParent(_height['cm']);
              })),
      Text(unit,
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
    ]);
  }

  Widget metricHeightPicker() => heightPicker('cm', 61, 272);

  Widget imperialHeightPicker() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [heightPicker('ft', 2, 8), heightPicker('in', 0, 11)]);
}
