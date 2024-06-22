import 'package:flutter/material.dart';

import 'package:aqua/screens/home.dart';
import 'package:aqua/screens/onboarding/form/profile.dart';
import 'package:aqua/firestore_utils.dart' as firestore;
import 'package:aqua/shared_pref_utils.dart' as shared_prefs;
import 'package:aqua/location_utils.dart';

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
        onPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        },
        child: const Text(
          "Let's go!",
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900),
        ));
  }
}

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

  Future<void> _createUser() async {
    if (!mounted) return;
    final location = await getCurrentLocation();
    print(location);
    await firestore.createUser(widget.profile, location);
    print('Firestore written!');
    await shared_prefs.createUser(widget.profile, location);
    print('Shared Prefs added!');
    await firestore.uploadProfilePicture(
        widget.profile.picture, widget.profile.name!);
    print('Profile picture uploaded!');
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loaded = true);
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
