import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

import 'package:aqua/screens/onboarding/form/profile.dart';
import 'package:aqua/screens/onboarding/form/nav_buttons.dart';
import 'package:aqua/shape_painter.dart';
import 'package:aqua/utils.dart' as utils;

class DobInputScreen extends StatefulWidget {
  const DobInputScreen({super.key});

  @override
  State<DobInputScreen> createState() => _DobInputScreenState();
}

// _safeDate is declared to ensure that user age is always >= 1 year
final DateTime _safeDate = DateTime.now().subtract(const Duration(days: 365));

class _DobInputScreenState extends State<DobInputScreen> {
  DateTime _selectedDate = _safeDate;

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
                    const SizedBox(
                        height: 200,
                        child: utils.OnboardingQuestion(
                          text: "When were you born?",
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: SizedBox(
                          height: 250,
                          child: CalendarDatePicker2(
                            config: CalendarDatePicker2Config(
                                daySplashColor: const Color(0x440264e1),
                                selectedDayHighlightColor:
                                    utils.defaultColors['dark blue'],
                                lastDate: _safeDate,
                                firstDate: DateTime(1920, 1, 1),
                                controlsTextStyle: const TextStyle(
                                    fontWeight: FontWeight.w900),
                                dayTextStyle: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                weekdayLabelTextStyle: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: utils.defaultColors['dark blue'])),
                            value: [_selectedDate],
                            onValueChanged: (date) => _selectedDate = date[0]!,
                          )),
                    ),
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
          context.flow<Profile>().update((profile) =>
              profile.copyWith(dob: _selectedDate).incrementPage());
        }));
  }
}
