import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/database/database.dart';

import 'package:aqua/screens/user_profile/profile.dart';
import 'package:aqua/screens/user_profile/statistics.dart';
import 'package:aqua/screens/user_profile/share_widget.dart';

/// The [UserProfile] screen is a composition of
/// [ProfileWidget], [StatsWidget] & [ShareWidget]
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
        body: SingleChildScrollView(
          child: Wrap(
                runSpacing: 15,
                children: [
          ProfileWidget(prefs: widget.prefs, db: widget.database),
          StatsWidget(prefs: widget.prefs, db: widget.database),
          ShareWidget(prefs: widget.prefs, db: widget.database)
                ],
              ),
        ));
  }
}
