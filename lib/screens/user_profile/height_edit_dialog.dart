import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/utils.dart' as utils;

class HeightEditDialog extends StatefulWidget {
  const HeightEditDialog(
      {super.key, required this.notifyParent, required this.prefs});

  final VoidCallback notifyParent;
  final SharedPreferences prefs;

  @override
  State<HeightEditDialog> createState() => _HeightEditDialogState();
}

class _HeightEditDialogState extends State<HeightEditDialog> {
  late DateTime dob;

  @override
  void initState() {
    dob = DateTime.parse(widget.prefs.getString('DOB')!);
    super.initState();
  }

  // _safeDate is declared to ensure that user age is always >= 1 year
  final DateTime _safeDate = DateTime.now().subtract(const Duration(days: 365));

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    Color canvasColor = Theme.of(context).canvasColor;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 7.5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
          side: BorderSide(color: primaryColor, width: 3)),
      backgroundColor: canvasColor,
      child: Container(
        height: 500,
        padding: const EdgeInsets.all(5),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                  daySplashColor: const Color(0x440264e1),
                  selectedDayHighlightColor: utils.defaultColors['dark blue'],
                  lastDate: _safeDate,
                  firstDate: DateTime(1920, 1, 1),
                  controlsTextStyle:
                      const TextStyle(fontWeight: FontWeight.w900),
                  dayTextStyle: const TextStyle(fontWeight: FontWeight.bold),
                  weekdayLabelTextStyle: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: utils.defaultColors['dark blue'])),
              value: [dob],
              onValueChanged: (dates) => dob = dates[0]!,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                utils.DialogActionButton(
                    icon: const Icon(Icons.check),
                    function: () async {
                      widget.prefs.setString('DOB', dob.toIso8601String());
                      Navigator.pop(context);
                      widget.notifyParent();
                    }),
                utils.DialogActionButton(
                  icon: const Icon(Icons.close),
                  function: () => Navigator.pop(context),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
