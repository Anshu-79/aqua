import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:numberpicker/numberpicker.dart';
import 'package:searchable_listview/searchable_listview.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils.dart' as utils;

class AddWorkoutDialog extends StatefulWidget {
  const AddWorkoutDialog({super.key, required this.notifyParent});
  final Function() notifyParent;

  @override
  State<AddWorkoutDialog> createState() => _AddWorkoutDialogState();
}

class _AddWorkoutDialogState extends State<AddWorkoutDialog> {
  late Database _db;

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
    return Dialog.fullscreen(
      backgroundColor: Theme.of(context).canvasColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 40, right: 10, left: 10),
        child: SearchableList<Activity>.async(
          spaceBetweenSearchAndList: 5,
          displaySearchIcon: false,
          cursorColor: Theme.of(context).primaryColor,
          closeKeyboardWhenScrolling: true,
          searchFieldEnabled: true,
          asyncListCallback: () async {
            final Future<List<Activity>> activities = _db.getActivities();
            return activities;
          },
          asyncListFilter: (q, list) {
            return list
                .where((element) => element.description.contains(q))
                .toList();
          },
          itemBuilder: (Activity activity) => ActivityItem(
            activity: activity,
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
    );
  }
}

class ActivityItem extends StatelessWidget {
  const ActivityItem({super.key, required this.activity});
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      textColor: Theme.of(context).primaryColor,
      leading: Icon(
        utils.icomoonMap[activity.category],
        size: 35,
      ),
      title: Text(activity.category),
      titleTextStyle: utils.ThemeText.listTileTitle,
      subtitle: Text(activity.description),
      isThreeLine: true,
      onTap: () {},
    );
  }
}