import 'package:aqua/screens/home/confetti.dart';
import 'package:aqua/screens/home/todays_drinks_dialog.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/screens/home/fab.dart';
import 'package:aqua/screens/home/water_animation.dart';
import 'package:aqua/screens/home/reminder_box.dart';
import 'package:aqua/database/database.dart';
import 'package:aqua/utils/widgets/universal_header.dart';

/// The [HomeScreen] consists of 3 main widgets: [ReminderBox], [WaterGoalWidget] & a cirular FAB.
/// It acts as a way of communication between the 3 widgets, passing callbacks across them.
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

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  final ValueNotifier<bool> _reminderBoxNotifier = ValueNotifier(false);

  void _triggerUpdate() =>
      _reminderBoxNotifier.value = !_reminderBoxNotifier.value;

  void _blastConfetti() => _confettiController.play();

  Future<WaterGoal> _getGoal() async {
    WaterGoal todaysGoal = await widget.database.setTodaysGoal();
    // set goal if not set already

    return todaysGoal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: const UniversalHeader(title: "Today's Goal"),
      body: FutureBuilder<WaterGoal>(
          future: _getGoal(),
          builder: (context, snapshot) {
            WaterGoal? todaysGoal = snapshot.data;

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            return homeScreen(
                todaysGoal!.consumedVolume, todaysGoal.totalVolume);
          }),
      floatingActionButton: homeScreenFAB(),
    );
  }

  Widget homeScreen(int consumed, int total) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            reminderBoxWidget(consumed, total),
            const SizedBox(height: 20),
            waterBoxWidget(consumed, total)
          ]),
        ),
        Confetti(controller: _confettiController)
      ],
    );
  }

  Widget reminderBoxWidget(int consumed, int total) {
    return ValueListenableBuilder<bool>(
        valueListenable: _reminderBoxNotifier,
        builder: (context, value, child) {
          return ReminderBox(
              db: widget.database,
              prefs: widget.prefs,
              isGoalCompleted: consumed >= total);
        });
  }

  Widget waterBoxWidget(int consumed, int total) {
    MaterialPageRoute todaysDrinksRoute = MaterialPageRoute(
        builder: (context) => TodaysDrinksDialog(db: widget.database));

    return Expanded(
      flex: 3,
      child: GestureDetector(
        onTap: () => Navigator.push(context, todaysDrinksRoute)
            .then((_) => setState(() {})),
        child: WaterGoalWidget(
            key: _waterGoalWidgetKey, consumedVol: consumed, totalVol: total),
      ),
    );
  }

  Widget homeScreenFAB() {
    return CircularFab(
      db: widget.database,
      notifyReminderBox: _triggerUpdate,
      startFillAnimation: (consumedVol) =>
          _waterGoalWidgetKey.currentState?.startFillAnimation(consumedVol),
      blastConfetti: _blastConfetti,
    );
  }
}
