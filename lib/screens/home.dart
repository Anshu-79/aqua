import 'package:aqua/dialog_boxes/add_drink.dart';
import 'package:fab_circular_menu_plus/fab_circular_menu_plus.dart';
import 'package:flutter/material.dart';

import 'package:aqua/water_animation.dart';
import 'package:aqua/utils.dart' as utils;
import 'package:aqua/icomoon_icons.dart';
import 'package:aqua/database/database.dart';

class ReminderBox extends StatelessWidget {
  const ReminderBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          border: Border.all(width: 4, color: Theme.of(context).primaryColor)),
      child: Row(children: [
        const Icon(Icons.alarm, size: 60),
        const SizedBox(width: 10),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Next reminder in", style: utils.ThemeText.reminderSubText),
              Text("20 minutes", style: utils.ThemeText.reminderText),
            ])
      ]),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.database});

  final Database database;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: const utils.UniversalHeader(title: "Today's Goal"),
      body: Container(
          margin: const EdgeInsets.all(20),
          child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                WaterGoalWidget(consumedVol: 1500, totalVol: 3000),
                SizedBox(height: 20),
                ReminderBox(),
              ])),
      floatingActionButton: FabCircularMenuPlus(
        animationDuration: const Duration(milliseconds: 200),
        alignment: Alignment.bottomCenter,
        fabSize: 70,
        ringDiameter: 300,
        ringColor: Theme.of(context).canvasColor.withOpacity(0.8),
        fabColor: Theme.of(context).splashColor,
        fabChild: GestureDetector(
            child: const Icon(Icons.add, size: 30),
            onLongPress: () async {
              await utils.GlobalNavigator.showAnimatedDialog(AddDrinkDialog(
                beverages: await widget.database.getBeverages(),
                notifyParent: refresh,
              ));
            }),
        children: const [
          Icon(Icomoon.coffee_cup),
          Icon(Icomoon.water_glass),
          Icon(Icomoon.soda_can),
        ],
      ),
    );
  }
}
