import 'package:flutter/material.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils/widgets/blank_screen.dart';
import 'package:aqua/utils/widgets/global_navigator.dart';
import 'package:aqua/utils/widgets/universal_fab.dart';
import 'package:aqua/utils/widgets/universal_header.dart';

import 'package:aqua/screens/activity_menu/activity_card.dart';
import 'package:aqua/screens/activity_menu/add_workout.dart';

/// The [ActivityMenu] displays the physical activities of a user for the current date
/// It uses a [FutureBuilder] to asynchronously fetch data from the database
/// Then displays the fetched data using a grid of [WorkoutCard]
/// The FAB opens [AddWorkoutDialog] which allows the user to choose an activity
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
      appBar: const UniversalHeader(title: "Today's Activities"),
      body: FutureBuilder<List<Workout>>(
        future: widget.database.getTodaysWorkouts(),
        builder: (context, snapshot) {
          final List<Workout>? workouts = snapshot.data;

          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor));
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
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
            return const BlankScreen(
                message: "No activities found.\nTry adding one!");
          }
        },
      ),
      floatingActionButton: UniversalFAB(
        tooltip: "Add new workout",
        onPressed: () async {
          await GlobalNavigator.showAnimatedDialog(AddWorkoutDialog(
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

