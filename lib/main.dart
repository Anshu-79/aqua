import 'package:aqua/firebase_options.dart';
import 'package:aqua/location_utils.dart';
import 'package:aqua/screens/onboarding/form/loading.dart';
import 'package:aqua/screens/onboarding/form/profile.dart';
import 'package:aqua/shared_pref_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/screens/home.dart';
import 'package:aqua/screens/user_profile.dart';
import 'package:aqua/screens/beverage_menu.dart';
import 'package:aqua/screens/activity_menu.dart';
import 'package:aqua/screens/onboarding/onboarding.dart';
import 'package:aqua/utils.dart' as utils;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(Aqua(
    sharedPrefs: prefs,
  ));
}

class Aqua extends StatefulWidget {
  const Aqua({super.key, required this.sharedPrefs});
  final SharedPreferences sharedPrefs;

  @override
  State<Aqua> createState() => _AquaState();
}

class _AquaState extends State<Aqua> {
  @override
  void initState() {
    super.initState();
  }

  final pages = [
    const HomeScreen(),
    const UserProfile(),
    const BeverageMenu(),
    const ActivityMenu(),
  ];

  @override
  Widget build(BuildContext context) {
    // if the app is running for the first time, onboard key will be null
    bool onboard = widget.sharedPrefs.getBool('onboard') ?? false;
    onboard = false;
    // widget.sharedPrefs.clear();
    print(widget.sharedPrefs.getKeys());

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: utils.lightTheme,
        darkTheme: utils.darkTheme,
        themeMode: ThemeMode.system,
        navigatorKey: navigatorKey,
        home: Builder(
          builder: (context) => !(onboard)
              ? const OnboardingView()
              : LiquidSwipe(
                  pages: pages,
                  fullTransitionValue: 600,
                  slideIconWidget: const Icon(Icons.arrow_back_ios_new_rounded),
                  positionSlideIcon: 0.71,
                ),
        ));
  }
}
