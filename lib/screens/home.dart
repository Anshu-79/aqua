import 'package:aqua/dialog_boxes/add_drink.dart';
import 'package:drift/drift.dart' as drift;
import 'package:fab_circular_menu_plus/fab_circular_menu_plus.dart';
import 'package:flutter/material.dart';

import 'package:aqua/water_animation.dart';
import 'package:aqua/utils.dart' as utils;
import 'package:aqua/icomoon_icons.dart';
import 'package:aqua/database/database.dart';

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
        floatingActionButton:
            CircularFab(db: widget.database, notifyParent: refresh));
  }
}

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

class CircularFab extends StatefulWidget {
  const CircularFab({super.key, required this.db, required this.notifyParent});
  final Database db;
  final VoidCallback notifyParent;

  @override
  State<CircularFab> createState() => _CircularFabState();
}

class _CircularFabState extends State<CircularFab> {
  late List<Widget> _fabButtons;
  bool _loading = true;

  @override
  void initState() {
    _loadFabButtons();
    super.initState();
  }

  Future<void> _loadFabButtons() async {
    final List<Beverage> starredBevs = await widget.db.getStarredBeverages();

    final widgets = List.generate(5, (idx) {
      final bev = starredBevs[idx];
      return GestureDetector(
        child: Column(
          children: [
            Icon(Icomoon.iced_liquid, color: utils.toColor(bev.colorCode)),
            Text(bev.name)
          ],
        ),
        onTap: () {},
        onLongPress: () {},
      );
    });

    setState(() {
      _fabButtons = widgets;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FabCircularMenuPlus(
      animationDuration: const Duration(milliseconds: 200),
      alignment: Alignment.bottomCenter,
      fabSize: 70,
      ringDiameter: 300,
      ringColor: Theme.of(context).canvasColor.withOpacity(0.8),
      fabColor: Theme.of(context).splashColor,
      fabChild: GestureDetector(
          child: const Icon(Icons.add, size: 30),
          onLongPress: () async {
            List<Beverage> beverages = await widget.db.getBeverages();
            await utils.GlobalNavigator.showAnimatedDialog(AddDrinkDialog(
              beverages: beverages,
              notifyParent: widget.notifyParent,
            ));
          }),
      children: _loading ? [const CircularProgressIndicator()] : _fabButtons,
    );
  }
}
