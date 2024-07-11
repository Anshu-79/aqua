import 'package:flutter/material.dart';

/// The [NavButtons] are essentially a [Row] of two IconButtons
/// They allow the user to go back and forth across the [OnboardingFlow]
class NavButtons extends StatelessWidget {
  const NavButtons({
    super.key,
    required this.navBack,
    required this.navForward,
  });
  final VoidCallback navBack;
  final VoidCallback navForward;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton.filled(
            icon: const Icon(Icons.chevron_left),
            iconSize: 50,
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).canvasColor,
            ),
            onPressed: navBack,
          ),
          IconButton.filled(
            icon: const Icon(Icons.chevron_right),
            iconSize: 50,
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).canvasColor,
            ),
            onPressed: navForward
          ),
        ],
      ),
    );
  }
}
