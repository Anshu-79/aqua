import 'package:flutter/material.dart';
import 'package:searchable_listview/searchable_listview.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils.dart' as utils;
import 'package:aqua/dialog_boxes/customize_workout.dart';

class AddWorkoutDialog extends StatefulWidget {
  const AddWorkoutDialog(
      {super.key, required this.notifyParent, required this.activities});
  final Function() notifyParent;
  final Future<List<Activity>> activities;

  @override
  State<AddWorkoutDialog> createState() => _AddWorkoutDialogState();
}

class _AddWorkoutDialogState extends State<AddWorkoutDialog> {
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
      body: Dialog.fullscreen(
        backgroundColor: Theme.of(context).canvasColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 60, right: 10, left: 10),
          child: Scrollbar(
            trackVisibility: true,
            child: SearchableList<Activity>.async(
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
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(20)),
                    splashColor: utils.getWorkoutColor(activity.activityID),
                    textColor: Theme.of(context).primaryColor,
                    tileColor: utils.lighten(
                        utils.getWorkoutColor(activity.activityID), 50),
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
                      
                      WorkoutsCompanion? addedWorkout = await showGeneralDialog(
                          barrierDismissible: false,
                          transitionDuration: const Duration(milliseconds: 150),
                          transitionBuilder: (context, a1, a2, child) {
                            return ScaleTransition(
                                scale: Tween<double>(begin: 0.5, end: 1.0)
                                    .animate(a1),
                                child: FadeTransition(
                                  opacity: Tween<double>(begin: 0.5, end: 1.0)
                                      .animate(a1),
                                  child: CustomizeWorkout(
                                    activity: activity,
                                    notifyParent: refresh,
                                  ),
                                ));
                          },
                          context: context,
                          pageBuilder: (context, a1, a2) {
                            return const Placeholder();
                          });

                      await _db.insertOrUpdateWorkout(addedWorkout!);
                      widget.notifyParent();
                    },
                  ),
                ),
              ),
              emptyWidget: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // TODO: Replace with mascot
                    Icon(
                      Icons.sentiment_dissatisfied_outlined,
                      size: 60,
                    ),
                    Text("Nothing in here!"),
                  ],
                ),
              ),
              onRefresh: () async {},
              onItemSelected: (Activity item) {},
              inputDecoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                floatingLabelStyle:
                    TextStyle(color: Theme.of(context).primaryColor),
                labelStyle: utils.ThemeText.searchLabelText,
                labelText: "Search Activity",
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.blue,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              errorWidget: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Error while fetching actors')
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
          child: Icon(
            Icons.close,
            color: Theme.of(context).canvasColor,
            size: 50,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
