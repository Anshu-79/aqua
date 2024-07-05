import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/water_goals.dart';
import 'package:aqua/utils.dart' as utils;
import 'package:aqua/screens/settings.dart';

String getWakeTimeText(SharedPreferences prefs) {
  int wakeTime = prefs.getInt('wakeTime')!;
  if (wakeTime >= 12) return "$wakeTime:00 PM";
  return "$wakeTime:00 AM";
}

String getSleepTimeText(SharedPreferences prefs) {
  int sleepTime = prefs.getInt('sleepTime')!;
  if (sleepTime >= 12) return "$sleepTime:00 PM";
  return "$sleepTime:00 AM";
}

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key, required this.prefs});
  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    String? imgPath = prefs.getString('photo_path');

    if (imgPath == null) {
      return const Icon(Icons.account_circle_rounded,
          size: 120, color: Colors.white);
    }
    FileImage img = FileImage(File(imgPath));
    return Align(
        alignment: Alignment.topCenter,
        child: CircleAvatar(radius: 60, backgroundImage: img));
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: IconButton(
          iconSize: 40,
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SettingsPage(prefs: prefs))),
        ),
      ),
    );
  }
}

class BiometricButton extends StatefulWidget {
  const BiometricButton(
      {super.key,
      required this.metric,
      required this.subtext,
      required this.callback});

  final int metric;
  final String subtext;
  final VoidCallback callback;

  @override
  State<BiometricButton> createState() => _BiometricButtonState();
}

class _BiometricButtonState extends State<BiometricButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: widget.callback,
        style: TextButton.styleFrom(
            elevation: 3,
            shadowColor: Colors.black,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(widget.metric.toString(), style: utils.ThemeText.biometricInfo),
          Text(widget.subtext, style: utils.ThemeText.biometricInfoSubtext)
        ]));
  }
}

class SleepScheduleButton extends StatefulWidget {
  const SleepScheduleButton(
      {super.key,
      required this.icon,
      required this.time,
      required this.callback});

  final Icon icon;
  final String time;
  final VoidCallback callback;

  @override
  State<SleepScheduleButton> createState() => _SleepScheduleButtonState();
}

class _SleepScheduleButtonState extends State<SleepScheduleButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: widget.callback,
        style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 3,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.icon,
              const SizedBox(width: 5),
              Text(widget.time, style: utils.ThemeText.sleepInfo)
            ]));
  }
}

class BioButtonsRow extends StatefulWidget {
  const BioButtonsRow({super.key, required this.prefs});
  final SharedPreferences prefs;

  @override
  State<BioButtonsRow> createState() => _BioButtonsRowState();
}

class _BioButtonsRowState extends State<BioButtonsRow> {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      BiometricButton(
          metric: calculateAge(widget.prefs.getString('DOB')!),
          subtext: "Age",
          callback: () {}),
      BiometricButton(
          metric: widget.prefs.getInt('height')!,
          subtext: "Height",
          callback: () {}),
      BiometricButton(
          metric: widget.prefs.getInt('weight')!,
          subtext: "Weight",
          callback: () {})
    ]);
  }
}

class SleepButtonsRow extends StatefulWidget {
  const SleepButtonsRow({super.key, required this.prefs});
  final SharedPreferences prefs;

  @override
  State<SleepButtonsRow> createState() => _SleepButtonsRowState();
}

class _SleepButtonsRowState extends State<SleepButtonsRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SleepScheduleButton(
              icon: Icon(Icons.sunny, color: utils.defaultColors['yellow']),
              time: getWakeTimeText(widget.prefs),
              callback: () {}),
          SleepScheduleButton(
              icon: Icon(Icons.bedtime, color: utils.defaultColors['violet']),
              time: getSleepTimeText(widget.prefs),
              callback: () {})
        ]);
  }
}
