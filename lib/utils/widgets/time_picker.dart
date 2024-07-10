import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({super.key, required this.time, required this.notifyParent});

  final int time;
  final Function notifyParent;

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  late int _time = widget.time;

  @override
  Widget build(BuildContext context) {
    const selectedStyle = TextStyle(fontSize: 50, fontWeight: FontWeight.w900);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NumberPicker(
          zeroPad: true,
          infiniteLoop: true,
          itemHeight: 70,
            minValue: 0,
            maxValue: 23,
            value: _time,
            selectedTextStyle: selectedStyle,
            textStyle: const TextStyle(fontSize: 20),
            onChanged: (t) {
              setState(() => _time = t);
              widget.notifyParent(t);
            }),
        const Text(":  00", style: selectedStyle),
      ],
    );
  }
}
