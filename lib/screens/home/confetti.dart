import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import 'package:aqua/utils/colors.dart';

/// Displays confetti when user completes their daily water goal
class Confetti extends StatefulWidget {
  const Confetti({super.key, required this.controller});
  final ConfettiController controller;

  @override
  State<Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<Confetti> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
          numberOfParticles: 15,
          confettiController: widget.controller,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: true,
          colors: shapeColors),
    );
  }
}
