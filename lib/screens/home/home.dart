import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/screens/home/fab.dart';
import 'package:aqua/screens/home/water_animation.dart';
import 'package:aqua/screens/home/reminder_box.dart';
import 'package:aqua/database/database.dart';
import 'package:aqua/utils.dart' as utils;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.database, required this.prefs});

  final Database database;
  final SharedPreferences prefs;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<WaterGoalWidgetState> _waterGoalWidgetKey =
      GlobalKey<WaterGoalWidgetState>();
      
  // The first element of this function's output stores a WaterGoal? object
  // the second stores an int
  Future<List<dynamic>> _getGoal() async {
    WaterGoal todaysGoal =
        await widget.database.setTodaysGoal(); // set goal if not set already

    int drinkSize = await widget.database.calcMedianDrinkSize();
    return [todaysGoal, drinkSize];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: const utils.UniversalHeader(title: "Today's Goal"),
      body: FutureBuilder<List<dynamic>>(
          future: _getGoal(),
          builder: (context, snapshot) {
            List<dynamic>? snapshotData = snapshot.data;

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            return Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ReminderBox(
                          reminderGap: snapshotData![0].reminderGap,
                          drinkSize: snapshotData[1], prefs: widget.prefs),
                      const SizedBox(height: 20),
                      WaterGoalWidget(
                          key: _waterGoalWidgetKey,
                          consumedVol: snapshotData[0].consumedVolume,
                          totalVol: snapshotData[0].totalVolume),
                    ]));
          }),
      floatingActionButton: CircularFab(
        db: widget.database,
        startFillAnimation: (consumedVol) {
          _waterGoalWidgetKey.currentState?.startFillAnimation(consumedVol);
        },
      ),
    );
  }
}

