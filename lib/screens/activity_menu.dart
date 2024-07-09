import 'package:flutter/material.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils.dart' as utils;
import 'package:aqua/dialog_boxes/add_workout.dart';

class ActivityMenu extends StatefulWidget {
  const ActivityMenu({super.key, required this.database});

  final Database database;

  @override
  State<ActivityMenu> createState() => _ActivityMenuState();
}

class _ActivityMenuState extends State<ActivityMenu> {
  refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const utils.UniversalHeader(title: "Today's Activities"),
      body: FutureBuilder<List<Workout>>(
        future: widget.database.getTodaysWorkouts(),
        builder: (context, snapshot) {
          final List<Workout>? workouts = snapshot.data;

          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (workouts != null && workouts.isNotEmpty) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final workout = workouts[index];

                return WorkoutCard(workout: workout);
              },
            );
          } else {
            // TODO: Replace with mascot
            return Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 150,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 3),
                    borderRadius: BorderRadius.circular(40)),
                child: IntrinsicHeight(
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.sentiment_dissatisfied, size: 80),
                          Text(
                            "No activities found.\nTry adding one!",
                            textAlign: TextAlign.center,
                            style: utils.ThemeText.emptyScreenText,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: utils.UniversalFAB(
        tooltip: "Add new workout",
        onPressed: () async {
          await utils.GlobalNavigator.showAnimatedDialog(AddWorkoutDialog(
            db: widget.database,
            activities: widget.database.getActivities(),
            notifyParent: refresh,
          ));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class WorkoutCard extends StatelessWidget {
  const WorkoutCard({super.key, required this.workout});
  final Workout workout;

  @override
  Widget build(BuildContext context) {
    Color bgColor = utils.getWorkoutColor(workout.activityID);
    Color primaryColor = Theme.of(context).primaryColor;

    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: bgColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: bgColor, width: 5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(utils.getWorkoutIcon(workout.activityID),
              color: primaryColor, size: 50),
          FittedBox(
              fit: BoxFit.contain,
              child: Text(utils.getWorkoutCategory(workout.activityID),
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: primaryColor))),
          Text(utils.getDurationInText(workout.duration),
              style:
                  TextStyle(color: primaryColor, fontWeight: FontWeight.w900)),
          Text(utils.getVolumeInText(workout.waterLoss),
              style:
                  TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
