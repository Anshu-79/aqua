import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/water_goals.dart';
import 'package:aqua/database/database.dart';
import 'package:aqua/icomoon_icons.dart';
import 'package:aqua/utils.dart' as utils;


getWakeTimeText(SharedPreferences prefs) {
  int wakeTime = prefs.getInt('wakeTime')!;
  if (wakeTime >= 12) return "$wakeTime:00 PM";
  return "$wakeTime:00 AM";
}

getSleepTimeText(SharedPreferences prefs) {
  int sleepTime = prefs.getInt('sleepTime')!;
  if (sleepTime >= 12) return "$sleepTime:00 PM";
  return "$sleepTime:00 AM";
}


class UserProfile extends StatefulWidget {
  const UserProfile({super.key, required this.database, required this.prefs});

  final Database database;
  final SharedPreferences prefs;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: utils.defaultColors['dark blue'],
                borderRadius: const BorderRadius.all(Radius.circular(35))),
            child: Column(
              children: [
                const SizedBox(height: 20),
                ProfilePicture(prefs: widget.prefs),
                const SizedBox(height: 10),
                Text(widget.prefs.getString('name')!,
                    style: utils.ThemeText.username),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(
                        "City, State, Country", //TODO: Use Weather API to get town name...
                        style: utils.ThemeText.userLocationSubtext)
                  ],
                ),
                const SizedBox(height: 20),
                BioButtonsRow(prefs: widget.prefs),
                const SizedBox(height: 30),
                SleepButtonsRow(prefs: widget.prefs),
                const SizedBox(height: 20)
              ],
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatsSummary(
                color: utils.defaultColors['red']!,
                stats: widget.prefs.getInt('streak')!.toString(),
                statsSubtext: "Day Streak",
                icondata: Icons.whatshot,
              ),
              StatsSummary(
                  color: utils.defaultColors['blue']!,
                  stats: "7.9 L",
                  statsSubtext: "Water per Week",
                  icondata: Icomoon.water_bottle)
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatsSummary(
                  color: utils.defaultColors['mint']!,
                  stats: "42 L",
                  statsSubtext: "Lifetime Intake",
                  icondata: Icons.calendar_month_sharp),
              StatsSummary(
                  color: utils.defaultColors['yellow']!,
                  stats: "10 L",
                  statsSubtext: "Fluids per Week",
                  icondata: Icomoon.iced_liquid)
            ],
          )
        ],
      ),
    );
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
    return CircleAvatar(radius: 60, backgroundImage: img);
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

class StatsSummary extends StatefulWidget {
  const StatsSummary(
      {super.key,
      required this.color,
      required this.stats,
      required this.statsSubtext,
      required this.icondata});

  final Color color;
  final IconData icondata;
  final String stats;
  final String statsSubtext;

  @override
  State<StatsSummary> createState() => StatsSummaryState();
}

class StatsSummaryState extends State<StatsSummary> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        height: 65,
        width: 150,
        decoration: BoxDecoration(
            color: widget.color.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: widget.color, width: 3)),
        child: Row(children: [
          Icon(widget.icondata, size: 30, color: widget.color),
          const SizedBox(width: 10),
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.stats, style: utils.ThemeText.userStats),
                Text(widget.statsSubtext,
                    style: utils.ThemeText.userStatsSubtext)
              ])
        ]));
  }
}
