import 'dart:io';

import 'package:flutter/material.dart';

import 'package:aqua/nav_bar.dart';
import 'package:aqua/screens/onboarding/form/profile.dart';
import 'package:aqua/utils/firestore_utils.dart' as firestore;
import 'package:aqua/utils/shared_pref_utils.dart' as shared_prefs;
import 'package:aqua/utils/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key, required this.profile});

  final Profile profile;

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _createUser();
  }

  @override
  void dispose() {
    super.dispose();
    _uploadProfilePicture();
  }

  Future<void> _createUser() async {
    if (!mounted) return;
    final location = await getCurrentLocation();

    await shared_prefs.createUser(widget.profile, location);

    await shared_prefs.savePictureLocally(
        widget.profile.picture, widget.profile.name!);

    await firestore.createUser(widget.profile, location);

    Future.delayed(const Duration(milliseconds: 1000));
    setState(() => _loaded = true);
  }

  Future<void> _uploadProfilePicture() async {
    File? img = await shared_prefs.getProfilePicture();
    await firestore.uploadProfilePicture(img, widget.profile.name!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1874d2),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Give us a few seconds",
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w900,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              "We're getting things ready!",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            SizedBox(
                height: 200,
                child: _loaded ? const ContinueButton() : const LoadingWhales())
          ],
        ),
      ),
    );
  }
}

class LoadingWhales extends StatelessWidget {
  const LoadingWhales({super.key});

  @override
  Widget build(BuildContext context) =>
      Image.asset('assets/images/loading_whales.gif');
}

class ContinueButton extends StatelessWidget {
  const ContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            backgroundColor: Colors.black, shape: const CircleBorder()),
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          if (context.mounted) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => NavBar(prefs: prefs)));
          }
        },
        child: const Text(
          "Let's go!",
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900),
        ));
  }
}
