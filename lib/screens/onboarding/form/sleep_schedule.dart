import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';

import 'package:aqua/screens/onboarding/form/profile.dart';
import 'package:aqua/screens/onboarding/form/nav_buttons.dart';
import 'package:aqua/shape_painter.dart';
import 'package:aqua/utils.dart' as utils;

class SleepScheduleInputScreen extends StatefulWidget {
  const SleepScheduleInputScreen({super.key});

  @override
  State<SleepScheduleInputScreen> createState() =>
      _SleepScheduleInputScreenState();
}

class _SleepScheduleInputScreenState extends State<SleepScheduleInputScreen> {
  @override
  Widget build(BuildContext context) {
    final Profile profile = context.flow<Profile>().state;
    int sleepTime = profile.sleepTime ?? 0;
    int wakeTime = profile.wakeTime ?? 8;

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
                          text: "What's your sleep schedule?",
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TimePicker(
                          height: 350,
                          width: 350,
                          initTime: PickedTime(h: sleepTime, m: 0),
                          endTime: PickedTime(h: wakeTime, m: 0),
                          onSelectionChange: (start, end, isDisableRange) {},
                          onSelectionEnd: (start, end, isDisableRange) {
                            sleepTime = start.h;
                            wakeTime = end.h;
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
                                  pickerColor: utils.defaultColors['dark blue'],
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
              .copyWith(sleepTime: sleepTime, wakeTime: wakeTime)
              .incrementPage());
        }));
  }
}
