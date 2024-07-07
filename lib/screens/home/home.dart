import 'package:flutter/material.dart';

import 'package:aqua/screens/home/fab.dart';
import 'package:aqua/screens/home/water_animation.dart';
import 'package:aqua/utils.dart' as utils;
import 'package:aqua/database/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.database});

  final Database database;

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
                          drinkSize: snapshotData[1]),
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

class ReminderBox extends StatelessWidget {
  const ReminderBox(
      {super.key, required this.reminderGap, required this.drinkSize});
  final int reminderGap;
  final int drinkSize;

  Widget getStyledText(String prefix, String styledText, String suffix) {
    return Text.rich(
      TextSpan(
        text: '$prefix ',
        style: utils.ThemeText.reminderSubText,
        children: <TextSpan>[
          TextSpan(text: styledText, style: utils.ThemeText.reminderText),
          TextSpan(text: ' $suffix', style: utils.ThemeText.reminderSubText),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          border: Border.all(width: 4, color: Theme.of(context).primaryColor)),
      child: Row(children: [
        const Icon(Icons.alarm, size: 55),
        const SizedBox(width: 5),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("We will remind you to",
                  style: utils.ThemeText.reminderSubText),
              getStyledText("drink", "$drinkSize mL", "water"),
              getStyledText("every", utils.getDurationInText(reminderGap), ''),
            ])
      ]),
    );
  }
}
