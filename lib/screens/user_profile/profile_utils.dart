import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/intake_calculations.dart';
import 'package:aqua/utils/miscellaneous.dart' as utils;
import 'package:aqua/utils/widgets/global_navigator.dart';
import 'package:aqua/utils/colors.dart';

import 'package:aqua/screens/user_profile/buttons.dart';
import 'package:aqua/screens/user_profile/dialogs/sleeptime_edit_dialog.dart';
import 'package:aqua/screens/user_profile/dialogs/waketime_edit_dialog.dart';
import 'package:aqua/screens/user_profile/dialogs/age_edit_dialog.dart';
import 'package:aqua/screens/user_profile/dialogs/height_edit_dialog.dart';
import 'package:aqua/screens/user_profile/dialogs/weight_edit_dialog.dart';

String getWakeTimeText(SharedPreferences prefs) =>
    utils.getTimeInText(prefs.getInt('wakeTime')!);

String getSleepTimeText(SharedPreferences prefs) =>
    utils.getTimeInText(prefs.getInt('sleepTime')!);

/// A [Row] of 3 [BiometricButton] for age, height & weight
class BioButtonsRow extends StatefulWidget {
  const BioButtonsRow({super.key, required this.prefs});
  final SharedPreferences prefs;

  @override
  State<BioButtonsRow> createState() => _BioButtonsRowState();
}

class _BioButtonsRowState extends State<BioButtonsRow> {
  refresh() => setState(() {});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      BiometricButton(
          metric: calculateAge(widget.prefs.getString('DOB')!),
          subtext: "Age",
          callback: () => GlobalNavigator.showAnimatedDialog(
              AgeEditDialog(notifyParent: refresh, prefs: widget.prefs))),
      BiometricButton(
          metric: widget.prefs.getInt('height')!,
          subtext: "Height",
          callback: () => GlobalNavigator.showAnimatedDialog(
              HeightEditDialog(notifyParent: refresh, prefs: widget.prefs))),
      BiometricButton(
          metric: widget.prefs.getInt('weight')!,
          subtext: "Weight",
          callback: () => GlobalNavigator.showAnimatedDialog(
              WeightEditDialog(notifyParent: refresh, prefs: widget.prefs)))
    ]);
  }
}

/// A [Row] of 2 [SleepScheduleButton] for sleepTime and wakeTime
class SleepButtonsRow extends StatefulWidget {
  const SleepButtonsRow({super.key, required this.prefs, required this.db});
  final SharedPreferences prefs;
  final Database db;

  @override
  State<SleepButtonsRow> createState() => _SleepButtonsRowState();
}

class _SleepButtonsRowState extends State<SleepButtonsRow> {
  refresh() => setState(() {});
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SleepScheduleButton(
              icon: const Icon(Icons.sunny, color: AquaColors.yellow),
              time: getWakeTimeText(widget.prefs),
              callback: () {
                GlobalNavigator.showAnimatedDialog(WaketimeEditDialog(
                    prefs: widget.prefs, db: widget.db, notifyParent: refresh));
              }),
          SleepScheduleButton(
              icon: const Icon(Icons.bedtime, color: AquaColors.violet),
              time: getSleepTimeText(widget.prefs),
              callback: () => GlobalNavigator.showAnimatedDialog(
                  SleeptimeEditDialog(
                      prefs: widget.prefs,
                      notifyParent: refresh,
                      db: widget.db)))
        ]);
  }
}
