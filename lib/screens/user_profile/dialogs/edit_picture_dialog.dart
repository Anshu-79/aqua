import 'dart:io';

import 'package:aqua/utils/shared_pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/utils/colors.dart';
import 'package:aqua/utils/widgets/global_navigator.dart';

/// This widget allows user to update their profile picture
/// It gives the option to either use the Camera or the Gallery
class EditPictureDialog extends StatefulWidget {
  const EditPictureDialog({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  State<EditPictureDialog> createState() => _EditPictureDialogState();
}

class _EditPictureDialogState extends State<EditPictureDialog> {
  dynamic img;

  Future<void> _pickImage(ImageSource source) async {
    Navigator.of(context).pop();

    final String username = widget.prefs.getString('name') ?? "profile_pic";
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      await savePictureLocally(File(pickedFile.path), username);
      GlobalNavigator.showSnackBar(
          "Picture will be updated soon!", AquaColors.darkBlue);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? imgPath = widget.prefs.getString('photo_path');

    if (imgPath == null) {
      img = const AssetImage('assets/images/selfie.gif');
    } else {
      img = FileImage(File(imgPath));
    }

    Color primaryColor = Theme.of(context).primaryColor;
    Color canvasColor = Theme.of(context).canvasColor;
    TextStyle buttonTextStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20, color: canvasColor);

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
          side: BorderSide(color: primaryColor, width: 3)),
      backgroundColor: canvasColor,
      child: SizedBox(
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
                radius: 100,
                backgroundColor: Theme.of(context).canvasColor,
                backgroundImage: img),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    style: TextButton.styleFrom(backgroundColor: primaryColor),
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: Text("Gallery", style: buttonTextStyle)),
                TextButton(
                    style: TextButton.styleFrom(backgroundColor: primaryColor),
                    onPressed: () => _pickImage(ImageSource.camera),
                    child: Text(
                      "Camera",
                      style: buttonTextStyle,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
