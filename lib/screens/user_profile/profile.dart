import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/screens/user_profile/profile_utils.dart';
import 'package:aqua/utils.dart' as utils;

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: utils.defaultColors['dark blue'],
          borderRadius: const BorderRadius.all(Radius.circular(35))),
      child: Column(children: [
        const SizedBox(height: 20),
        Stack(
          children: [
            ProfilePicture(prefs: widget.prefs),
            const SettingsButton()
          ],
        ),
        const SizedBox(height: 10),
        Text(widget.prefs.getString('name')!, style: utils.ThemeText.username),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, color: Colors.white),
            const SizedBox(width: 10),
            Text(widget.prefs.getString('place')!,
                style: utils.ThemeText.userLocationSubtext)
          ],
        ),
        const SizedBox(height: 20),
        BioButtonsRow(prefs: widget.prefs),
        const SizedBox(height: 30),
        SleepButtonsRow(prefs: widget.prefs),
        const SizedBox(height: 20)
      ]),
    );
  }
}
