import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

import 'package:aqua/screens/onboarding/form/profile.dart';
import 'package:aqua/screens/onboarding/form/nav_buttons.dart';
import 'package:aqua/shape_painter.dart';

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
                    Container(
                      height: 200,
                      child: AnimatedTextKit(
                        totalRepeatCount: 1,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            "When were you born?",
                            textStyle: const TextStyle(
                                fontSize: 50, fontWeight: FontWeight.w800),
                            textAlign: TextAlign.center,
                            cursor: '|',
                            speed: const Duration(milliseconds: 100),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: SizedBox(
                          height: 250,
                          child: CalendarDatePicker2(
                            config: CalendarDatePicker2Config(
                                daySplashColor: const Color(0x440264e1),
                                selectedDayHighlightColor:
                                    const Color(0xFF0264e1),
                                lastDate: _safeDate,
                                firstDate: DateTime(1920, 1, 1),
                                controlsTextStyle: const TextStyle(
                                    fontWeight: FontWeight.w900),
                                dayTextStyle: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                weekdayLabelTextStyle: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF0264e1))),
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
