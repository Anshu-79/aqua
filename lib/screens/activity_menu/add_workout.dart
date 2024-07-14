import 'package:flutter/material.dart';
import 'package:searchable_listview/searchable_listview.dart';

import 'package:aqua/utils/notifications.dart';
import 'package:aqua/utils/icons.dart';
import 'package:aqua/utils/widgets/blank_screen.dart';
import 'package:aqua/database/database.dart';
import 'package:aqua/screens/activity_menu/customize_workout.dart';
import 'package:aqua/utils/widgets/global_navigator.dart';
import 'package:aqua/utils/colors.dart';
import 'package:aqua/screens/activity_menu/helpers.dart';

/// This dialog provides a [List] of [Activity] to choose from
/// It uses a [SearchableList] to asynchronously load the activities
/// The search box can be used to search either [Activity.category] or [Activity.description]
class AddWorkoutDialog extends StatefulWidget {
  const AddWorkoutDialog(
      {super.key,
      required this.notifyParent,
      required this.activities,
      required this.db});
  final Database db;
  final Function() notifyParent;
  final Future<List<Activity>> activities;

  @override
  State<AddWorkoutDialog> createState() => _AddWorkoutDialogState();
}

class _AddWorkoutDialogState extends State<AddWorkoutDialog> {
  ScrollController controller = ScrollController();

  refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Dialog.fullscreen(
        backgroundColor: Theme.of(context).canvasColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 60, right: 10, left: 10),
          child: Scrollbar(
              thickness: 20,
              radius: const Radius.circular(10),
              controller: controller,
              interactive: true,
              trackVisibility: true,
              child: ActivityList(
                  db: widget.db,
                  scrollController: controller,
                  activities: widget.activities,
                  notifyParent: widget.notifyParent)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: () => Navigator.pop(context),
          tooltip: "Exit",
          backgroundColor: Theme.of(context).primaryColor,
          splashColor: Theme.of(context).splashColor,
          shape: const CircleBorder(eccentricity: 0),
          child:
              Icon(Icons.close, color: Theme.of(context).canvasColor, size: 50),
        ),
      ),
    );
  }
}

class ActivityList extends StatefulWidget {
  const ActivityList(
      {super.key,
      required this.db,
      required this.scrollController,
      required this.activities,
      required this.notifyParent});

  final Database db;
  final ScrollController scrollController;
  final Future<List<Activity>> activities;
  final Function() notifyParent;

  @override
  State<ActivityList> createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  @override
  Widget build(BuildContext context) {
    return SearchableList<Activity>.async(
      scrollController: widget.scrollController,
      spaceBetweenSearchAndList: 10,
      displaySearchIcon: false,
      cursorColor: Theme.of(context).primaryColor,
      searchFieldEnabled: true,
      asyncListCallback: () async {
        return widget.activities;
      },
      asyncListFilter: (q, list) {
        q = q.trim().toLowerCase();
        return list
            .where((element) =>
                element.category.toLowerCase().contains(q) ||
                element.description.toLowerCase().contains(q))
            .toList();
      },
      itemBuilder: (Activity activity) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        // This Card Widget is wrapped over ListTile to prevent ListTiles
        // from displaying over searchbar
        child: Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: ListTile(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: getWorkoutColor(activity.id), width: 5),
                borderRadius: BorderRadius.circular(30)),
            splashColor: getWorkoutColor(activity.id),
            textColor: Theme.of(context).primaryColor,
            tileColor: getWorkoutColor(activity.id).withOpacity(0.1),
            leading: Icon(workoutIconMap[activity.category]![0], size: 35),
            title: Text(activity.category),
            titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
            subtitle: Text(activity.description),
            isThreeLine: true,
            onTap: () async {
              Navigator.pop(context);

              WorkoutsCompanion? addedWorkout =
                  await GlobalNavigator.showAnimatedDialog(
                      CustomizeWorkout(activity: activity));

              await widget.db.insertOrUpdateWorkout(addedWorkout!);

              await widget.db.updateTotalVolume(addedWorkout.waterLoss.value);
              widget.notifyParent();

              // Update notification gap
              WaterGoal? todaysGoal = await widget.db.getGoal(DateTime.now());
              int medianDrinkSize = await widget.db.calcMedianDrinkSize();
              await NotificationsController.updateScheduledNotifications(
                  todaysGoal!.reminderGap, medianDrinkSize);
            },
          ),
        ),
      ),
      emptyWidget: const BlankScreen(message: "Nothing in here!"),
      onRefresh: () async {},
      onItemSelected: (Activity item) {},
      inputDecoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        floatingLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
        labelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        labelText: "Search Activity",
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AquaColors.darkBlue, width: 3.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      errorWidget: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Colors.red),
          SizedBox(height: 20),
          Text('Error while fetching activities')
        ],
      ),
    );
  }
}
