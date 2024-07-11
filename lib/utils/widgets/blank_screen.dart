import 'package:aqua/theme_manager.dart';
import 'package:flutter/material.dart';

/// This widget is displayed when there is nothing else to be displayed
/// Currently, it is used on the Activity Menu
class BlankScreen extends StatelessWidget {
  const BlankScreen({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = ThemeNotifier.of(context);
    bool isDark = themeNotifier.isDarkMode;

    String imgName = isDark ? "empty_dark.gif" : "empty_light.gif";

    return Center(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(50),
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor, width: 5),
              borderRadius: BorderRadius.circular(35)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(image: AssetImage('assets/images/$imgName')),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)
              )
            ],
          ),
        ),
      ),
    );
  }
}
