import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';

import 'package:aqua/screens/onboarding/form/profile.dart';
import 'package:aqua/screens/onboarding/form/nav_buttons.dart';
import 'package:aqua/shape_painter.dart';

class SleepScheduleInputScreen extends StatefulWidget {
  const SleepScheduleInputScreen({super.key});

  @override
  State<SleepScheduleInputScreen> createState() =>
      _SleepScheduleInputScreenState();
}

class _SleepScheduleInputScreenState extends State<SleepScheduleInputScreen> {
  int _sleepTime = 0;
  int _wakeTime = 8;

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
                    SizedBox(
                      height: 200,
                      child: AnimatedTextKit(
                        totalRepeatCount: 1,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            "What's your sleep schedule like?",
                            textStyle: const TextStyle(
                                fontSize: 40, fontWeight: FontWeight.w800),
                            textAlign: TextAlign.center,
                            cursor: '|',
                            speed: const Duration(milliseconds: 100),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TimePicker(
                          height: 350,
                          width: 350,
                          initTime: PickedTime(h: _sleepTime, m: 0),
                          endTime: PickedTime(h: _wakeTime, m: 0),
                          onSelectionChange: (start, end, isDisableRange) {},
                          onSelectionEnd: (start, end, isDisableRange) {
                            _sleepTime = start.h;
                            _wakeTime = end.h;
                          },
                          decoration: TimePickerDecoration(
                              clockNumberDecoration:
                                  TimePickerClockNumberDecoration(
                                      defaultTextColor:
                                          Theme.of(context).primaryColor,
                                      defaultFontSize: 35,
                                      textScaleFactor: 0.8,
                                      scaleFactor: 1,
                                      positionFactor: 0.45,
                                      clockIncrementHourFormat:
                                          ClockIncrementHourFormat.three,
                                      clockIncrementTimeFormat:
                                          ClockIncrementTimeFormat.sixtyMin,
                                      endNumber: 0),
                              baseColor: const Color(0x440264e1),
                              sweepDecoration: TimePickerSweepDecoration(
                                  pickerColor: const Color(0xFF0264e1),
                                  pickerStrokeWidth: 40),
                              initHandlerDecoration:
                                  TimePickerHandlerDecoration(
                                icon: const Icon(Icons.bedtime),
                                color: Colors.transparent,
                              ),
                              endHandlerDecoration: TimePickerHandlerDecoration(
                                icon: const Icon(Icons.wb_sunny),
                                color: Colors.transparent,
                              )),
                        )),
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
          context.flow<Profile>().update((profile) => profile
              .copyWith(sleepTime: _sleepTime, wakeTime: _wakeTime)
              .incrementPage());
        }));
  }
}
