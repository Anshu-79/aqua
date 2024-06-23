import 'package:aqua/database/database.dart';
import 'package:flutter/material.dart';

import 'package:aqua/icomoon_icons.dart';
import 'package:aqua/utils.dart' as utils;

class UserProfile extends StatefulWidget {
  const UserProfile({super.key, required this.database});

  final Database database;

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
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  IconButton(
                      iconSize: 100,
                      icon: const Icon(
                        Icons.account_circle_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {}),
                  Text(
                    "Anshumaan Tanwar",
                    style: utils.ThemeText.username,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "City, State, Country",
                        style: utils.ThemeText.userLocationSubtext,
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BiometricButton(
                          text: "18", subtext: "Age", callback: () {}),
                      BiometricButton(
                          text: "175", subtext: "Height", callback: () {}),
                      BiometricButton(
                          text: "64", subtext: "Weight", callback: () {})
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SleepScheduleButton(
                          icon: Icon(
                            Icons.sunny,
                            color: utils.defaultColors['yellow'],
                          ),
                          time: "8:00 AM",
                          callback: () {}),
                      SleepScheduleButton(
                          icon: Icon(
                            Icons.bedtime,
                            color: utils.defaultColors['violet'],
                          ),
                          time: "2:00 AM",
                          callback: () {})
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatsSummary(
                color: utils.defaultColors['red']!,
                stats: "7",
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

class BiometricButton extends StatefulWidget {
  const BiometricButton(
      {super.key,
      required this.text,
      required this.subtext,
      required this.callback});

  final String text;
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
            borderRadius: BorderRadius.circular(15),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.text,
            style: utils.ThemeText.biometricInfo,
          ),
          Text(
            widget.subtext,
            style: utils.ThemeText.biometricInfoSubtext,
          )
        ],
      ),
    );
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.icon,
          const SizedBox(
            width: 5,
          ),
          Text(
            widget.time,
            style: utils.ThemeText.sleepInfo,
          )
        ],
      ),
    );
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
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        height: 65,
        width: 150,
        decoration: BoxDecoration(
            color: widget.color.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: widget.color, width: 3)),
        child: Row(
          children: [
            Icon(widget.icondata, size: 30, color: widget.color),
            const SizedBox(
              width: 10,
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.stats,
                    style: utils.ThemeText.userStats,
                  ),
                  Text(
                    widget.statsSubtext,
                    style: utils.ThemeText.userStatsSubtext,
                  )
                ])
          ],
        ));
  }
}
