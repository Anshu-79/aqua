import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import 'package:aqua/home.dart';
import 'package:aqua/user_profile.dart';

void main() {
  runApp(Aqua());
}
class Aqua extends StatelessWidget {
  Aqua({super.key});

  final pages = [
    HomeScreen(),
    UserProfile()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'CeraPro'
      ),
      //darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Builder(
        builder: (context) => LiquidSwipe(
          pages: pages,
          fullTransitionValue: 600,
          slideIconWidget: Icon(Icons.arrow_back_ios_new_rounded),
          positionSlideIcon: 0.6,),
        ));
  }
}