import 'package:aqua/screens/home/confetti.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/screens/home/fab.dart';
import 'package:aqua/screens/home/water_animation.dart';
import 'package:aqua/screens/home/reminder_box.dart';
import 'package:aqua/database/database.dart';
import 'package:aqua/utils/widgets/universal_header.dart';

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
            return Stack(
              children: [
                Container(
                    margin: const EdgeInsets.all(20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ValueListenableBuilder<bool>(
                              valueListenable: _reminderBoxNotifier,
                              builder: (context, value, child) {
                                return ReminderBox(
                                    db: widget.database,
                                    prefs: widget.prefs,
                                    isGoalCompleted:
                                        todaysGoal!.consumedVolume >=
                                            todaysGoal.totalVolume);
                              }),
                          const SizedBox(height: 20),
                          WaterGoalWidget(
                              key: _waterGoalWidgetKey,
                              consumedVol: todaysGoal!.consumedVolume,
                              totalVol: todaysGoal.totalVolume),
                        ])),
                Confetti(controller: _confettiController)
              ],
            );
          }),
      floatingActionButton: CircularFab(
        db: widget.database,
        notifyReminderBox: _triggerUpdate,
        startFillAnimation: (consumedVol) {
          _waterGoalWidgetKey.currentState?.startFillAnimation(consumedVol);
        },
        blastConfetti: _blastConfetti,
      ),
    );
  }
}
