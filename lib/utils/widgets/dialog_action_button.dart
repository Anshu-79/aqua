import 'package:flutter/material.dart';

class DialogActionButton extends StatelessWidget {
  const DialogActionButton(
      {super.key, required this.icon, required this.function});
  final Icon icon;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      icon: icon,
      iconSize: 50,
      onPressed: () => function(),
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).canvasColor,
      )
    );
  }
}
