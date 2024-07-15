import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/theme_manager.dart';
import 'package:aqua/timers.dart';
import 'package:aqua/utils/weather_utils.dart';
import 'package:aqua/api_keys.dart';
import 'package:aqua/utils/notifications.dart';
import 'package:aqua/firebase_options.dart';
import 'package:aqua/nav_bar.dart';

import 'package:aqua/screens/onboarding/onboarding.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  // Firebase initialization
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // SharedPreferences initialization
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // If app is opened for the first time (ie onboard = false), API key is written onto device
  if (prefs.getBool('onboard') == null) writeAPIKey('weather', openWeatherKey);

  // Notifications initialization
  await NotificationsController.initLocalNotifications();

  // Runs every time app is run but fetches weather only when day has changed
  // Does a check on onboard to not fetch weather when app is run for the first time
  // This was done to prevent asking multiple permissions at once.
  if (prefs.getBool('onboard') != null) await DailyTaskManager.checkAndRunTask(saveWeather);

  NotificationsController.shiftNotificationsIfSleeping();

  runApp(Aqua(sharedPrefs: prefs));
}

class Aqua extends StatefulWidget {
  const Aqua({super.key, required this.sharedPrefs});
  final SharedPreferences sharedPrefs;

  @override
  State<Aqua> createState() => _AquaState();
}

class _AquaState extends State<Aqua> {
  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    // if the app is running for the first time, onboard key will be null
    bool onboard = widget.sharedPrefs.getBool('onboard') ?? false;
    print(widget.sharedPrefs.getBool('darkMode'));
    return ThemeManager(
      prefs: widget.sharedPrefs,
      child: Builder(builder: (context) {
        final themeNotifier = ThemeNotifier.of(context);
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode:
                themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            navigatorKey: navigatorKey,
            home: Builder(
                builder: (context) => !(onboard)
                    ? const OnboardingView()
                    : NavBar(prefs: widget.sharedPrefs)));
      }),
    );
  }
}
