import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/screens/user_profile/profile.dart';
import 'package:aqua/screens/user_profile/statistics.dart';
import 'package:aqua/database/database.dart';

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
                runSpacing: 20,
                children: [
          ProfileWidget(prefs: widget.prefs, db: widget.database),
          StatsWidget(prefs: widget.prefs, db: widget.database)
                ],
              ),
        ));
  }
}
