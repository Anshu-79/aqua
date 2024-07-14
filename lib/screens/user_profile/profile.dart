import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/utils/colors.dart';
import 'package:aqua/database/database.dart';

import 'package:aqua/screens/user_profile/profile_picture.dart';
import 'package:aqua/screens/user_profile/buttons.dart';
import 'package:aqua/screens/user_profile/profile_utils.dart';
import 'package:aqua/screens/user_profile/name_widget.dart';
import 'package:aqua/screens/user_profile/location_widget.dart';

/// Encapsulates the profile section of the UserProfile page
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
    return Stack(children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: const BoxDecoration(
            color: AquaColors.darkBlue,
            borderRadius: BorderRadius.all(Radius.circular(35))),
        child: Wrap(
            runAlignment: WrapAlignment.spaceEvenly,
            runSpacing: 25,
            children: [
              ProfilePicture(prefs: widget.prefs),
              NameWidget(prefs: widget.prefs),
              LocationWidget(prefs: widget.prefs),
              BioButtonsRow(prefs: widget.prefs),
              SleepButtonsRow(prefs: widget.prefs, db: widget.db),
            ]),
      ),
      Padding(
          padding: const EdgeInsets.only(right: 10, top: 20),
          child: SettingsButton(prefs: widget.prefs)),
    ]);
  }
}
