
import 'dart:ui';

import 'package:aqua/screens/onboarding/form/name.dart';
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
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const Aqua());
}

class Aqua extends StatefulWidget {
  const Aqua({super.key});

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
    Brightness systemBrightness = Brightness.light;
    // systemBrightness = PlatformDispatcher.instance.platformBrightness;

    Color primaryColor = Colors.black;
    Color canvasColor = Colors.white;
    Color splashColor = const Color(0xFF44A4EE);

    if (systemBrightness == Brightness.dark) {
      primaryColor = Colors.white;
      canvasColor = Colors.black;
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'CeraPro',
          brightness: systemBrightness,
          primaryColor: primaryColor,
          canvasColor: canvasColor,
          splashColor: splashColor,
          scaffoldBackgroundColor: canvasColor,
        ),
        themeMode: ThemeMode.system,
        navigatorKey: navigatorKey,
        home: Builder(builder: (context) => const OnboardingView()
            // LiquidSwipe(
            //   pages: pages,
            //   fullTransitionValue: 600,
            //   slideIconWidget: const Icon(Icons.arrow_back_ios_new_rounded),
            //   positionSlideIcon: 0.71,
            // ),
            ));
  }
}
