import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/utils/textstyles.dart';
import 'package:aqua/screens/settings/settings.dart';

/// This button opens the [SettingsPage] when clicked
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

/// 3 instances of this button are used to display
/// editable Age, Height & Weight on the profile screen
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
          Text(widget.metric.toString(),
              style: ProfileScreenStyles.biometricInfo),
          Text(widget.subtext, style: ProfileScreenStyles.biometricInfoSubtext)
        ]));
  }
}

/// 2 occurences of this button are used to display
/// editable Sleeping time & Wake-up time on the profile screen
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
              Text(widget.time, style: ProfileScreenStyles.sleepInfo)
            ]));
  }
}
