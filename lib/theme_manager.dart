import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/utils/colors.dart';

/// Controls the [Brightness] of app
class ThemeNotifier extends InheritedWidget {
  final bool isDarkMode;
  final Function(bool) setTheme;

  const ThemeNotifier({
    super.key,
    required this.isDarkMode,
    required this.setTheme,
    required Widget child,
  }) : super(child: child);

  static ThemeNotifier of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ThemeNotifier>()!;

  @override
  bool updateShouldNotify(ThemeNotifier oldWidget) =>
      oldWidget.isDarkMode != isDarkMode;
}

class ThemeManager extends StatefulWidget {
  final Widget child;
  final SharedPreferences prefs;
  const ThemeManager({super.key, required this.child, required this.prefs});

  @override
  State<ThemeManager> createState() => _ThemeManagerState();
}

class _ThemeManagerState extends State<ThemeManager> {
  late bool isDarkMode;
  late SharedPreferences prefs;

  @override
  void initState() {
    final bool systemDarkMode =
        PlatformDispatcher.instance.platformBrightness == Brightness.dark;
    setState(
        () => isDarkMode = widget.prefs.getBool('darkMode') ?? systemDarkMode);

    super.initState();
  }

  void _setTheme(bool value) {
    setState(() => isDarkMode = value);
    prefs.setBool('darkMode', value);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeNotifier(
        isDarkMode: isDarkMode, setTheme: _setTheme, child: widget.child);
  }
}

ThemeData lightTheme = ThemeData(
    fontFamily: 'CeraPro',
    primaryColor: Colors.black,
    canvasColor: Colors.white,
    splashColor: AquaColors.darkBlue,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
        seedColor: AquaColors.darkBlue.toMaterialColor(),
        brightness: Brightness.light));

ThemeData darkTheme = ThemeData(
    fontFamily: 'CeraPro',
    primaryColor: Colors.white,
    canvasColor: Colors.black,
    splashColor: AquaColors.darkBlue,
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
        seedColor: AquaColors.darkBlue.toMaterialColor(),
        brightness: Brightness.dark));
