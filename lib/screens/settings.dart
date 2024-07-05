import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:aqua/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/utils.dart' as utils;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.prefs});
  final SharedPreferences prefs;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const utils.UniversalHeader(title: "Settings"),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Theme", style: utils.ThemeText.themeSubtext),
                    showThemeModeToggle()
                  ]),
            )
          ],
        ),
      ),
    );
  }

  Widget showThemeModeToggle() {
    final themeNotifier = ThemeNotifier.of(context);
    
    return AnimatedToggleSwitch.dual(
      borderWidth: 3,
      current: themeNotifier.isDarkMode,
      first: false,
      second: true,
      spacing: 20,
      height: 50,
      onChanged: (b) => themeNotifier.setTheme(b),
      textBuilder: (b) => b
          ? Text('Dark', style: utils.ThemeText.themeToggle)
          : Text('Light', style: utils.ThemeText.themeToggle),
      iconBuilder: (b) => b
          ? const Icon(Icons.bedtime, color: Colors.white)
          : const Icon(Icons.sunny, color: Colors.white),
      styleBuilder: (b) => ToggleStyle(
          backgroundColor: Theme.of(context).canvasColor,
          borderColor: Theme.of(context).primaryColor,
          indicatorColor: b
              ? utils.defaultColors['violet']
              : utils.defaultColors['yellow']),
    );
  }
}
