import 'package:aqua/database/database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/screens/user_profile/profile_utils.dart';
import 'package:aqua/utils.dart' as utils;

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key, required this.prefs, required this.db});

  final SharedPreferences prefs;
  final Database db;

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      decoration: BoxDecoration(
          color: utils.defaultColors['dark blue'],
          borderRadius: const BorderRadius.all(Radius.circular(35))),
      child: Column(children: [
        Stack(
          children: [
            ProfilePicture(prefs: widget.prefs),
            SettingsButton(prefs: widget.prefs),
          ],
        ),
        const SizedBox(height: 10),
        NameWidget(prefs: widget.prefs),
        const SizedBox(height: 10),
        LocationWidget(prefs: widget.prefs),
        const SizedBox(height: 10),
        BioButtonsRow(prefs: widget.prefs),
        const SizedBox(height: 30),
        SleepButtonsRow(prefs: widget.prefs, db: widget.db),
      ]),
    );
  }
}
