import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/screens/home.dart';
import 'package:aqua/screens/user_profile.dart';
import 'package:aqua/screens/beverage_menu.dart';
import 'package:aqua/timers.dart';

Future<SharedPreferences> setPrefs() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setDouble('wakeTime', 8);
  prefs.setDouble('sleepTime', 2.5);

  return prefs;
}


void main() {
  runApp(const Aqua());
}

class Aqua extends StatefulWidget {
  const Aqua({super.key});

  @override
  State<Aqua> createState() => _AquaState();
}

class _AquaState extends State<Aqua> {
  late double? wakeTime;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  void _loadPrefs() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    wakeTime = prefs.getDouble('wakeTime');
  });
}

  final pages = [
    const HomeScreen(),
    const UserProfile(),
    const BeverageMenu(),
  ];

  @override
  Widget build(BuildContext context) {
    Brightness systemBrightness = Brightness.light;
    // systemBrightness = MediaQuery.of(context).platformBrightness;

    Color primaryColor = Colors.black;
    Color canvasColor = Colors.white;
    Color splashColor = const Color(0xFF44A4EE);

    if (systemBrightness == Brightness.dark) {
      primaryColor = Colors.white;
      canvasColor = Colors.black;
    }

    dayChanger(wakeTime!);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'CeraPro',
          brightness: systemBrightness,
          primaryColor: primaryColor,
          canvasColor: canvasColor,
          splashColor: splashColor,
        ),
        themeMode: ThemeMode.system,
        home: Builder(
          builder: (context) => LiquidSwipe(
            pages: pages,
            fullTransitionValue: 600,
            slideIconWidget: const Icon(Icons.arrow_back_ios_new_rounded),
            positionSlideIcon: 0.71,
          ),
        ));
  }
}
