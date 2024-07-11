import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/screens/charts/charts.dart';
import 'package:aqua/screens/home/home.dart';
import 'package:aqua/screens/user_profile/user_profile.dart';
import 'package:aqua/screens/beverage_menu/beverage_menu.dart';
import 'package:aqua/screens/activity_menu/activity_menu.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils/colors.dart';

/// The [NavBar] widget passes database variables to all screens
/// along with displaying a Material 3 [NavigationBar]
class NavBar extends StatefulWidget {
  const NavBar({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late Database _db;

  int selectedPage = 0;

  @override
  void initState() {
    _db = Database();
    super.initState();
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }

  void _onItemTapped(int index) => setState(() => selectedPage = index);

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(database: _db, prefs: widget.prefs),
      StatsScreen(db: _db),
      UserProfile(database: _db, prefs: widget.prefs),
      ActivityMenu(database: _db),
      BeverageMenu(database: _db),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: pages[selectedPage],
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          }),
      bottomNavigationBar: NavigationBar(
        surfaceTintColor: AquaColors.darkBlue,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: _onItemTapped,
        indicatorColor: AquaColors.darkBlue,
        selectedIndex: selectedPage,
        destinations: const [
          NavigationDestination(
            label: 'Home',
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
          ),
          NavigationDestination(
            label: 'Statistics',
            icon: Icon(Icons.insert_chart_outlined_rounded),
            selectedIcon: Icon(Icons.insert_chart_rounded),
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
