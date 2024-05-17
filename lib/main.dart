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
    var systemBrightness = View.of(context).platformDispatcher.platformBrightness;
    systemBrightness = Brightness.light;

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        fontFamily: 'CeraPro',
        brightness: systemBrightness
      ),
      //darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Builder(
        builder: (context) => LiquidSwipe(
          pages: pages,
          fullTransitionValue: 600,
          slideIconWidget: const Icon(Icons.arrow_back_ios_new_rounded),
          positionSlideIcon: 0.6,),
        ));
  }
}