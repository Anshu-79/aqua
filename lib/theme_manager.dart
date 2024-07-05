import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/utils.dart' as utils;

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

  const ThemeManager({super.key, required this.child});

  @override
  State<ThemeManager> createState() => _ThemeManagerState();
}

class _ThemeManagerState extends State<ThemeManager> {
  late bool isDarkMode;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    final bool systemDarkMode =
        PlatformDispatcher.instance.platformBrightness == Brightness.dark;
    setState(() => isDarkMode = prefs.getBool('darkMode') ?? systemDarkMode);
  }

  void _setTheme(bool value) {
    setState(() => isDarkMode = value);
    prefs.setBool('darkMode', value);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeNotifier(
      isDarkMode: isDarkMode,
      setTheme: _setTheme,
      child: widget.child,
    );
  }
}

ThemeData lightTheme = ThemeData(
    fontFamily: 'CeraPro',
    primaryColor: Colors.black,
    canvasColor: Colors.white,
    splashColor: utils.defaultColors['dark blue'],
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
        seedColor: utils.defaultColors['dark blue']!.toMaterialColor(),
        brightness: Brightness.light));

ThemeData darkTheme = ThemeData(
    fontFamily: 'CeraPro',
    primaryColor: Colors.white,
    canvasColor: Colors.black,
    splashColor: utils.defaultColors['dark blue'],
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
        seedColor: utils.defaultColors['dark blue']!.toMaterialColor(),
        brightness: Brightness.dark));
