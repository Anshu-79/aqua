import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import 'package:aqua/home.dart';
import 'package:aqua/user_profile.dart';
import 'package:aqua/beverage_menu.dart';

void main() {
  runApp(Aqua());
}

class Aqua extends StatelessWidget {
  Aqua({super.key});

  final pages = [
    HomeScreen(),
    UserProfile(),
    BeverageMenu(),
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
