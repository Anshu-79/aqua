import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

import 'package:aqua/utils/widgets/tooltip.dart';
import 'package:aqua/screens/onboarding/form/profile.dart';
import 'package:aqua/screens/onboarding/form/nav_buttons.dart';
import 'package:aqua/shape_painter.dart';
import 'package:aqua/utils/miscellaneous.dart' as utils;
import 'package:aqua/utils/colors.dart';

String tooltipMessage =
    "Age is crucial for calculating AWI (Adequate Water Intake)";

class DobInputScreen extends StatefulWidget {
  const DobInputScreen({super.key});

  @override
  State<DobInputScreen> createState() => _DobInputScreenState();
}

// _safeDate is declared to ensure that user age is always >= 1 year
final DateTime _safeDate = DateTime.now().subtract(const Duration(days: 365));

class _DobInputScreenState extends State<DobInputScreen> {
  @override
  Widget build(BuildContext context) {
    final Profile profile = context.flow<Profile>().state;
    DateTime selectedDate = profile.dob ?? _safeDate;

    Widget datePicker() {
      return CalendarDatePicker2(
        config: CalendarDatePicker2Config(
            daySplashColor: const Color(0x440264e1),
            selectedDayHighlightColor: AquaColors.darkBlue,
            lastDate: _safeDate,
            firstDate: DateTime(1920, 1, 1),
            controlsTextStyle: const TextStyle(fontWeight: FontWeight.w900),
            dayTextStyle: const TextStyle(fontWeight: FontWeight.bold),
            weekdayLabelTextStyle: const TextStyle(
                fontWeight: FontWeight.w900, color: AquaColors.darkBlue)),
        value: [selectedDate],
        onValueChanged: (dates) => selectedDate = dates[0]!,
      );
    }

    return Scaffold(
        body: Stack(
          children: [
            ColoredShapesBackground(),
            TooltipOnTap(message: tooltipMessage),
            Container(
              margin: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const utils.OnboardingQuestion(text: "When were you born?"),
                    const SizedBox(height: 40),
                    datePicker()
                  ]),
            ),
          ],
        ),
        bottomNavigationBar: NavButtons(navBack: () {
          context.flow<Profile>().update((profile) => profile.decrementPage());
        }, navForward: () {
          context.flow<Profile>().update(
              (profile) => profile.copyWith(dob: selectedDate).incrementPage());
        }));
  }
}
