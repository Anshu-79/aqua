import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/utils/widgets/global_navigator.dart';
import 'package:aqua/screens/user_profile/dialogs/edit_picture_dialog.dart';

/// This widget displays the locally stored profile picture
/// The picture path is obtained from shared_preferences
/// If no image is found, an icon is displayed
class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key, required this.prefs});
  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    String? imgPath = prefs.getString('photo_path');

    return InkWell(
        onTap: () =>
            GlobalNavigator.showAnimatedDialog(EditPictureDialog(prefs: prefs)),
        child: displayedPicture(imgPath));
  }

  Widget displayedPicture(String? imgPath) {
    if (imgPath == null) {
      return const Center(
          child: Icon(Icons.account_circle_rounded,
              size: 120, color: Colors.white));
    }

    FileImage img = FileImage(File(imgPath));
    return InkWell(
      onTap: () =>
          GlobalNavigator.showAnimatedDialog(EditPictureDialog(prefs: prefs)),
      child: Align(
          alignment: Alignment.topCenter,
          child: CircleAvatar(radius: 60, backgroundImage: img)),
    );
  }
}
