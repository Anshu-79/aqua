import 'package:aqua/icomoon_icons.dart';
import 'package:flutter/material.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils.dart' as utils;
import 'package:aqua/dialog_boxes/add_workout.dart';

class ActivityMenu extends StatefulWidget {
  const ActivityMenu({super.key});

  @override
  State<ActivityMenu> createState() => _ActivityMenuState();
}

class _ActivityMenuState extends State<ActivityMenu> {
  late Database _db;

  refresh() => setState(() {});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: AppBar(
            elevation: 0,
            shape: BeveledRectangleBorder(
                side: BorderSide.none, borderRadius: BorderRadius.circular(10)),
            centerTitle: true,
            titleTextStyle: utils.ThemeText.screenHeader,
            title: Text("Today's Activities",
                maxLines: 2,
                style: TextStyle(
                    fontSize: 39,
                    color: Theme.of(context).primaryColor,
                    fontFamily: "CeraPro")),
            foregroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: FutureBuilder<List<Workout>>(
        future: _db.getTodaysWorkouts(),
        builder: (context, snapshot) {
          final List<Workout>? workouts = snapshot.data;
          // print(workouts);

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
                return Container(
                    child: Icon(utils.getWorkoutIcon(workout.activityID)));
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
            WorkoutsCompanion? addedWorkout = await showGeneralDialog(
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
                        ),
                      ));
                },
                context: context,
                pageBuilder: (context, a1, a2) {
                  return const Placeholder();
                });
            await _db.insertOrUpdateWorkout(addedWorkout!);
          },
          tooltip: "Add new beverage",
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
