import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'package:aqua/utils/colors.dart';

/// The [UniversalHeader] generates a colorized Animated text
/// that can be easily used as an appbar for a [Scaffold] 
class UniversalHeader extends PreferredSize {
  const UniversalHeader({super.key, required this.title})
      : super(
            preferredSize: const Size.fromHeight(60),
            child: const Placeholder());

  final String title;

  @override
  Widget build(BuildContext context) {
    TextStyle screenHeader = TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 45,
        fontWeight: FontWeight.w900,
        fontFamily: "CeraPro");

    return AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: screenHeader,
        title: FittedBox(
          fit: BoxFit.contain,
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              ColorizeAnimatedText(
                title,
                textStyle: screenHeader,
                speed: const Duration(milliseconds: 500),
                colors: headerColors,
              )
            ],
          ),
        ));
  }
}
