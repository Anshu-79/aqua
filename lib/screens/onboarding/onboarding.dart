import 'package:aqua/screens/onboarding/form/loading.dart';
import 'package:aqua/screens/onboarding/form/profile.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';

import 'package:aqua/screens/onboarding/congrats.dart';
import 'package:aqua/screens/onboarding/goals.dart';
import 'package:aqua/screens/onboarding/progress.dart';
import 'package:aqua/screens/onboarding/reminders.dart';
import 'package:aqua/screens/onboarding/welcome.dart';
import 'package:aqua/screens/onboarding/location.dart';
import 'package:aqua/screens/onboarding/form/form.dart';
import 'package:aqua/utils.dart' as utils;

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView>
    with SingleTickerProviderStateMixin {
  late Image logo;
  late Image reminderIcon;
  late Image progressIcon;
  late Image congratsIcon;
  late Image person1;
  late Image person2;
  late Image person3;
  late Image globe;

  final screens = [
    Beach(builder: (context) => const WelcomeScreen()),
    Beach(builder: (context) => const GoalScreen()),
    Beach(builder: (context) => const LocationScreen()),
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

    logo = Image.asset('assets/images/logo.png');
    reminderIcon = Image.asset('assets/images/reminder.gif');
    progressIcon = Image.asset('assets/images/progress.gif');
    congratsIcon = Image.asset('assets/images/congrats.gif');
    person1 = Image.asset('assets/images/person1.png');
    person2 = Image.asset('assets/images/person2.png');
    person3 = Image.asset('assets/images/person3.png');
    globe = Image.asset('assets/images/globe.gif');
  }

  @override
  void didChangeDependencies() {
    precacheImage(logo.image, context);
    precacheImage(reminderIcon.image, context);
    precacheImage(progressIcon.image, context);
    precacheImage(congratsIcon.image, context);
    precacheImage(person1.image, context);
    precacheImage(person2.image, context);
    precacheImage(person3.image, context);
    precacheImage(globe.image, context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    coastController.dispose();
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

  Widget scrollDown() {
    return SlideTransition(
      position: _animation,
      child: Tooltip(
        message: 'Swipe down to continue',
        child: Icon(
          Icons.expand_more,
          size: 70,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget getStarted() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: utils.defaultColors['dark blue']),
      width: MediaQuery.of(context).size.width * .9,
      height: 55,
      child: TextButton(
          onPressed: () async {
            final profile =
                await Navigator.of(context).push(OnboardingFlow.route());
            // const profile = Profile();
            if (!mounted) return;
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => LoadingScreen(
                          profile: profile!,
                        )));
          },
          child: const Text(
            "Get started",
            style: TextStyle(color: Colors.white, fontSize: 20),
          )),
    );
  }
}
