import 'package:aqua/screens/onboarding/congrats.dart';
import 'package:aqua/screens/onboarding/goals.dart';
import 'package:aqua/screens/onboarding/progress.dart';
import 'package:aqua/screens/onboarding/reminders.dart';
import 'package:aqua/screens/onboarding/welcome.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:aqua/utils.dart' as utils;
import 'package:aqua/screens/home.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final screens = [
    Beach(builder: (context) => const WelcomeScreen()),
    Beach(builder: (context) => const GoalScreen()),
    Beach(builder: (context) => const ReminderScreen()),
    Beach(builder: (context) => const ProgressScreen()),
    Beach(builder: (context) => const CongratsScreen()),
  ];
  final pageController = PageController();
  final coastController = CoastController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        color: Theme.of(context).canvasColor,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: isLastPage
            ? getStarted()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Skip Button
                  TextButton(
                      onPressed: () =>
                          pageController.jumpToPage(screens.length - 1),
                      child: const Text("Skip")),

                  //Indicator
                  SmoothPageIndicator(
                    controller: pageController,
                    count: screens.length,
                    onDotClicked: (index) => pageController.animateToPage(index,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeIn),
                    effect: WormEffect(
                      dotHeight: 12,
                      dotWidth: 12,
                      activeDotColor: utils.defaultColors['blue']!,
                    ),
                  ),

                  //Next Button
                  TextButton(
                      onPressed: () => pageController.nextPage(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeIn),
                      child: const Text("Next")),
                ],
              ),
      ),
      body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Coast(
              onPageChanged: (index) =>
                  setState(() => isLastPage = screens.length - 1 == index),
              controller: coastController,
              observers: [CrabController()],
              beaches: screens)),
    );
  }

  //Now the problem is when press get started button
  // after re run the app we see again the onboarding screen
  // so lets do one time onboarding

  //Get started button

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
