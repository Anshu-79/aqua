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

class ExtendedFabButton extends StatelessWidget {
  const ExtendedFabButton({super.key, required this.bev});
  final Beverage? bev;
  static const double iconSize = 45;

  @override
  Widget build(BuildContext context) {
    if (bev == null) return const SizedBox.shrink();

    return SizedBox(
      child: TextButton(
          style: TextButton.styleFrom(
            shadowColor: Colors.black,
              elevation: 6,
              shape: const CircleBorder(),
              backgroundColor: utils.toColor(bev!.colorCode)),
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icomoon.water_glass,
                    color: Colors.white, size: iconSize),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: iconSize),
                  child: Text(bev!.name,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          )),
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
  int fabButtonsCount = 3;
  bool _loading = true;
  bool _fabOpen = false;

  @override
  void initState() {
    _loadFabButtons();
    super.initState();
  }

  Future<void> _loadFabButtons() async {
    final List<Beverage> starBevs = await widget.db.getStarredBeverages();

    if (starBevs.length < fabButtonsCount) fabButtonsCount = starBevs.length;

    final widgets = List.generate(fabButtonsCount, (idx) {
      final bev = starBevs[idx];
      return ExtendedFabButton(bev: bev);
    });

    // Adding Placeholder widgets at the start & end of list
    // so that the item is displayed at the center
    if (widgets.length < 2) {
      widgets.add(const ExtendedFabButton(bev: null));
      widgets.insert(0, const ExtendedFabButton(bev: null));
    }

    setState(() {
      _fabButtons = widgets;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FabCircularMenuPlus(
      onDisplayChange: (isOpen) => setState(() => _fabOpen = isOpen),
      animationDuration: const Duration(milliseconds: 500),
      alignment: Alignment.bottomCenter,
      fabSize: 70,
      ringDiameter: 350,
      ringWidth: 100,
      ringColor: Colors.transparent,
      fabColor: Theme.of(context).splashColor,
      fabChild: GestureDetector(
          child: _fabOpen
              ? const Icon(Icons.close, size: 30)
              : const Icon(Icons.add, size: 30),
          onLongPress: () async {
            List<Beverage> beverages = await widget.db.getBeverages();
            await utils.GlobalNavigator.showAnimatedDialog(AddDrinkDialog(
              beverages: beverages,
              notifyParent: widget.notifyParent,
            ));
          }),
      children: _loading
          ? List.generate(2, (idx) => const CircularProgressIndicator())
          : _fabButtons,
    );
  }
}
