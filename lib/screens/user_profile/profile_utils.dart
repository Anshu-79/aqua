import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/weather_utils.dart';
import 'package:aqua/water_goals.dart';
import 'package:aqua/utils.dart' as utils;
import 'package:aqua/screens/settings.dart';

import 'package:aqua/screens/user_profile/sleeptime_edit_dialog.dart';
import 'package:aqua/screens/user_profile/waketime_edit_dialog.dart';
import 'package:aqua/screens/user_profile/age_edit_dialog.dart';
import 'package:aqua/screens/user_profile/height_edit_dialog.dart';
import 'package:aqua/screens/user_profile/name_edit_dialog.dart';
import 'package:aqua/screens/user_profile/weight_edit_dialog.dart';

String getTimeText(int time) {
  if (time > 12) return "${time - 12}:00 PM";
  if (time == 12) return "12:00 PM";
  return "$time:00 AM";
}

String getWakeTimeText(SharedPreferences prefs) =>
    getTimeText(prefs.getInt('wakeTime')!);

String getSleepTimeText(SharedPreferences prefs) =>
    getTimeText(prefs.getInt('sleepTime')!);

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

class NameWidget extends StatefulWidget {
  const NameWidget({super.key, required this.prefs});
  final SharedPreferences prefs;

  @override
  State<NameWidget> createState() => _NameWidgetState();
}

class _NameWidgetState extends State<NameWidget> {
  refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final String name = widget.prefs.getString('name')!;

    return TextButton(
      style: TextButton.styleFrom(
          elevation: 5,
          shadowColor: Colors.black,
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      child: Text(name,
          style: utils.ThemeText.username, overflow: TextOverflow.ellipsis),
      onPressed: () => utils.GlobalNavigator.showAnimatedDialog(NameEditDialog(
          name: name, notifyParent: refresh, prefs: widget.prefs)),
    );
  }
}

class LocationWidget extends StatefulWidget {
  const LocationWidget({super.key, required this.prefs});
  final SharedPreferences prefs;
  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  @override
  Widget build(BuildContext context) {
    String place = widget.prefs.getString('place')!;

    return TextButton(
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_on, color: Colors.white),
          const SizedBox(width: 10),
          Text(place, style: utils.ThemeText.userLocationSubtext),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              utils.GlobalNavigator.showSnackBar(
                  'Updating location...', utils.defaultColors['dark blue']);

              await saveWeather();
              setState(() {});
              utils.GlobalNavigator.showSnackBar(
                  'Location updated', utils.defaultColors['dark blue']);
            },
          )
        ],
      ),
    );
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
  refresh() => setState(() {});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      BiometricButton(
          metric: calculateAge(widget.prefs.getString('DOB')!),
          subtext: "Age",
          callback: () => utils.GlobalNavigator.showAnimatedDialog(
              AgeEditDialog(notifyParent: refresh, prefs: widget.prefs))),
      BiometricButton(
          metric: widget.prefs.getInt('height')!,
          subtext: "Height",
          callback: () => utils.GlobalNavigator.showAnimatedDialog(
              HeightEditDialog(notifyParent: refresh, prefs: widget.prefs))),
      BiometricButton(
          metric: widget.prefs.getInt('weight')!,
          subtext: "Weight",
          callback: () => utils.GlobalNavigator.showAnimatedDialog(
              WeightEditDialog(notifyParent: refresh, prefs: widget.prefs)))
    ]);
  }
}

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
              icon: Icon(Icons.sunny, color: utils.defaultColors['yellow']),
              time: getWakeTimeText(widget.prefs),
              callback: () {
                utils.GlobalNavigator.showAnimatedDialog(WaketimeEditDialog(
                    prefs: widget.prefs, db: widget.db, notifyParent: refresh));
              }),
          SleepScheduleButton(
              icon: Icon(Icons.bedtime, color: utils.defaultColors['violet']),
              time: getSleepTimeText(widget.prefs),
              callback: () => utils.GlobalNavigator.showAnimatedDialog(
                  SleeptimeEditDialog(
                      prefs: widget.prefs,
                      notifyParent: refresh,
                      db: widget.db)))
        ]);
  }
}
