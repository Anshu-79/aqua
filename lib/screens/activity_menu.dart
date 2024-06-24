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
          print(workouts);

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
              padding: const EdgeInsets.symmetric(horizontal: 5),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final workout = workouts[index];

                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: utils.lighten(
                            utils.getWorkoutColor(workout.activityID), 30),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 3)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            utils.getWorkoutIcon(workout.activityID),
                            color: Colors.black,
                            size: 50,
                          ),
                          FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                utils.getWorkoutCategory(workout.activityID),
                                style: utils.ThemeText.workoutTitle,
                              )),
                          Text(
                            utils.getInText(workout.duration),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
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
                          const Icon(
                            Icons.sentiment_dissatisfied,
                            size: 80,
                          ),
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
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: () async {
            await showGeneralDialog(
                barrierDismissible: false,
                transitionDuration: const Duration(milliseconds: 150),
                transitionBuilder: (context, a1, a2, child) {
                  return ScaleTransition(
                      scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                      child: FadeTransition(
                        opacity:
                            Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                        child: AddWorkoutDialog(
                          notifyParent: refresh,
                          activities: widget.database.getActivities(),
                        ),
                      ));
                },
                context: context,
                pageBuilder: (context, a1, a2) {
                  return const Placeholder();
                });
          },
          tooltip: "Add new workout",
          backgroundColor: Theme.of(context).primaryColor,
          splashColor: Theme.of(context).splashColor,
          shape: const CircleBorder(eccentricity: 0),
          child: Icon(
            Icons.add,
            color: Theme.of(context).canvasColor,
            size: 50,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
