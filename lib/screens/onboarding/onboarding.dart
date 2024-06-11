import 'package:aqua/screens/onboarding/congrats.dart';
import 'package:aqua/screens/onboarding/goals.dart';
import 'package:aqua/screens/onboarding/progress.dart';
import 'package:aqua/screens/onboarding/reminders.dart';
import 'package:aqua/screens/onboarding/welcome.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/utils.dart' as utils;
import 'package:aqua/screens/home.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView>
    with SingleTickerProviderStateMixin {
  final screens = [
    Beach(builder: (context) => const WelcomeScreen()),
    Beach(builder: (context) => const GoalScreen()),
    Beach(builder: (context) => const ReminderScreen()),
    Beach(builder: (context) => const ProgressScreen()),
    Beach(builder: (context) => const CongratsScreen()),
  ];

  final coastController = CoastController();
  bool isLastPage = false;
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0.2),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Coast(
              onPageChanged: (index) =>
                  setState(() => isLastPage = screens.length - 1 == index),
              controller: coastController,
              scrollDirection: Axis.vertical,
              observers: [CrabController()],
              beaches: screens)),
      floatingActionButton: isLastPage ? getStarted() : scrollDown(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  //Now the problem is when press get started button
  // after re run the app we see again the onboarding screen
  // so lets do one time onboarding

  //Get started button

  Widget scrollDown() {
    return SlideTransition(
        position: _animation,
        child: Icon(
          Icons.expand_more,
          size: 70,
          color: Theme.of(context).primaryColor,
        ),
      );
  }

  Widget getStarted() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: utils.defaultColors['blue']!),
      width: MediaQuery.of(context).size.width * .9,
      height: 55,
      child: TextButton(
          onPressed: () async {
            final pres = await SharedPreferences.getInstance();
            pres.setBool("onboarding", true);

            //After we press get started button this onboarding value become true
            // same key
            if (!mounted) return;
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
          child: const Text(
            "Get started",
            style: TextStyle(color: Colors.white, fontSize: 20),
          )),
    );
  }
}
