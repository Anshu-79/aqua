import 'package:aqua/notifications.dart';
import 'package:aqua/utils/blank_screen.dart';
import 'package:flutter/material.dart';
import 'package:searchable_listview/searchable_listview.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils.dart' as utils;
import 'package:aqua/dialog_boxes/customize_workout.dart';

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
            child: SearchableList<Activity>.async(
              scrollController: controller,
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: utils.getWorkoutColor(activity.id),
                            width: 5),
                        borderRadius: BorderRadius.circular(30)),
                    splashColor: utils.getWorkoutColor(activity.id),
                    textColor: Theme.of(context).primaryColor,
                    tileColor:
                        utils.getWorkoutColor(activity.id).withOpacity(0.2),
                    leading: Icon(
                      utils.icomoonMap[activity.category]![0],
                      size: 35,
                    ),
                    title: Text(activity.category),
                    titleTextStyle: utils.ThemeText.listTileTitle,
                    subtitle: Text(activity.description),
                    isThreeLine: true,
                    onTap: () async {
                      Navigator.pop(context);
            
                      WorkoutsCompanion? addedWorkout =
                          await utils.GlobalNavigator.showAnimatedDialog(
                              CustomizeWorkout(activity: activity));
            
                      await widget.db.insertOrUpdateWorkout(addedWorkout!);
            
                      await widget.db
                          .updateTotalVolume(addedWorkout.waterLoss.value);
                      widget.notifyParent();
            
                      // Update notification gap
                      WaterGoal? todaysGoal =
                          await widget.db.getGoal(DateTime.now());
                      int medianDrinkSize =
                          await widget.db.calcMedianDrinkSize();
                      await NotificationsController
                          .updateScheduledNotifications(
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
                floatingLabelStyle:
                    TextStyle(color: Theme.of(context).primaryColor),
                labelStyle: utils.ThemeText.searchLabelText,
                labelText: "Search Activity",
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: utils.defaultColors['dark blue']!, width: 3.0),
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
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: "Exit",
          backgroundColor: Theme.of(context).primaryColor,
          splashColor: Theme.of(context).splashColor,
          shape: const CircleBorder(eccentricity: 0),
          child:
              Icon(Icons.close, color: Theme.of(context).canvasColor, size: 50),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
