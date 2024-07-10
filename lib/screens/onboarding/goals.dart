import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';

import 'package:aqua/utils/colors.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  final PageController _pageController =
      PageController(viewportFraction: 0.4, initialPage: 1);
  int _currentPage = 1;
  final int _pageCount = 9;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (Timer timer) {
      if (_currentPage < _pageCount - 2) {
        _currentPage++;
      } else {
        _currentPage = 1;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: 130,
                child: SizedBox(
                    height: 20,
                    child: Crab(
                        tag: 'graphic',
                        child: Image.asset('assets/images/icon.png',
                            fit: BoxFit.contain)))),
            Image.asset('assets/images/lamp.png', width: 400, height: 400),
            Column(
              children: [
                const SizedBox(height: 190),
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pageCount,
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          double value = 1.0;
                          if (_pageController.position.haveDimensions) {
                            value = _pageController.page! - index;
                            value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                          }
                          return Center(
                            child: SizedBox(
                                height: Curves.easeInOut.transform(value) * 300,
                                width: Curves.easeInOut.transform(value) * 200,
                                child: Transform.scale(
                                  scale: Curves.easeInOut.transform(value),
                                  child: Opacity(opacity: value, child: child),
                                )),
                          );
                        },
                        child: Image.asset(
                            'assets/images/person${index + 1}.png',
                            fit: BoxFit.contain),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 30),
        AnimatedTextKit(repeatForever: true, animatedTexts: [
          ColorizeAnimatedText(
            "Tailored Goals",
            textAlign: TextAlign.center,
            textStyle:
                const TextStyle(fontSize: 45, fontWeight: FontWeight.w900),
            colors: textColorizeColors,
            speed: const Duration(milliseconds: 500),
          )
        ]),
        const SizedBox(height: 20),
        const Text(
          "Everyone's hydration needs are unique. Tell us about yourself, and we'll create a personalized water intake goal for you.",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.normal, color: Colors.grey),
        )
      ],
    );
  }
}
