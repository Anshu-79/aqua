import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/timers.dart';
import 'package:aqua/weather_utils.dart';
import 'package:aqua/api_keys.dart';
import 'package:aqua/database/database.dart';
import 'package:aqua/notifications.dart';
import 'package:aqua/firebase_options.dart';
import 'package:aqua/screens/home.dart';
import 'package:aqua/screens/user_profile/user_profile.dart';
import 'package:aqua/screens/beverage_menu.dart';
import 'package:aqua/screens/activity_menu.dart';
import 'package:aqua/screens/onboarding/onboarding.dart';
import 'package:aqua/utils.dart' as utils;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.getBool('onboard') != true) writeAPIKey('weather', openWeatherKey);

  await NotificationsController.initLocalNotifications();

  // Runs every time app is run but fetches weather only when day has changed
  await DailyTaskManager.checkAndRunTask(saveWeather);

  await DailyTaskManager.checkAndRunTask(
      NotificationsController.killNotificationsDuringSleepTime);

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

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: utils.lightTheme,
        darkTheme: utils.darkTheme,
        themeMode: ThemeMode.system,
        navigatorKey: navigatorKey,
        home: Builder(
            builder: (context) => !(onboard)
                ? const OnboardingView()
                : NavBar(prefs: widget.sharedPrefs)));
  }
}

class NavBar extends StatefulWidget {
  const NavBar({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late Database _db;

  int selectedPage = 0;
  final PageController pageController = PageController();

  @override
  void initState() {
    _db = Database();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    _db.close();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedPage = index;
      pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(database: _db),
      UserProfile(database: _db, prefs: widget.prefs),
      ActivityMenu(database: _db),
      BeverageMenu(database: _db),
    ];

    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        surfaceTintColor: utils.defaultColors['dark blue'],
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: _onItemTapped,
        indicatorColor: utils.defaultColors['dark blue'],
        selectedIndex: selectedPage,
        destinations: const [
          NavigationDestination(
            label: 'Home',
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
          ),
          NavigationDestination(
            label: 'Profile',
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
          ),
          NavigationDestination(
            label: 'Activities',
            icon: Icon(Icons.directions_run),
            selectedIcon: Icon(Icons.directions_run),
          ),
          NavigationDestination(
            label: 'Beverages',
            icon: Icon(Icons.emoji_food_beverage_outlined),
            selectedIcon: Icon(Icons.emoji_food_beverage),
          ),
        ],
      ),
    );
  }
}
