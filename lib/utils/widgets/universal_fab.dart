import 'package:flutter/material.dart';

class UniversalFAB extends StatelessWidget {
  const UniversalFAB(
      {super.key, required this.tooltip, required this.onPressed});
  final String tooltip;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 70,
      child: FloatingActionButton(
        tooltip: tooltip,
        backgroundColor: Theme.of(context).primaryColor,
        splashColor: Theme.of(context).splashColor,
        shape: const CircleBorder(eccentricity: 0),
        onPressed: () => onPressed(),
        child: Icon(Icons.add, color: Theme.of(context).canvasColor, size: 30),
      ),
    );
  }
}
