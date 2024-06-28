import 'package:aqua/dialog_boxes/add_drink.dart';
import 'package:fab_circular_menu_plus/fab_circular_menu_plus.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;

import 'package:aqua/water_animation.dart';
import 'package:aqua/utils.dart' as utils;
import 'package:aqua/icomoon_icons.dart';
import 'package:aqua/database/database.dart';

const double ICONSIZE = 45;

Future<void> showDrinkAddedSnackbar(DrinksCompanion drink, Beverage bev) async {
  String msg = "${drink.volume.value} mL of ${bev.name} added!";
  Color color = utils.toColor(bev.colorCode);

  utils.GlobalNavigator.showSnackBar(msg, color);
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
  const ExtendedFabButton(
      {super.key, this.bev, required this.db, required this.notifyParent});
  final Beverage? bev;
  final Database db;
  final VoidCallback notifyParent;

  _addQuickDrink() async {
    DrinksCompanion drink = DrinksCompanion(
        bevID: drift.Value(bev!.id),
        volume: const drift.Value(200),
        datetime: drift.Value(DateTime.now()));
    await db.insertOrUpdateDrink(drink);
    showDrinkAddedSnackbar(drink, bev!);
  }

  @override
  Widget build(BuildContext context) {
    if (bev == null) return const SizedBox.shrink();

    return SizedBox(
      child: TextButton(
          style: TextButton.styleFrom(
            shadowColor: Colors.black,
            elevation: 6,
            backgroundColor: utils.toColor(bev!.colorCode),
            shape: const CircleBorder(
                side: BorderSide(color: Colors.white, width: 2)),
          ),
          onPressed: _addQuickDrink,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icomoon.water_glass,
                    color: Colors.black, size: ICONSIZE),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: ICONSIZE),
                  child: Text(bev!.name,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
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
  final int maxFabButtonsCount = 3;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFabButtons();
  }

  Future<void> _loadFabButtons() async {
    final List<Beverage> starBevs = await widget.db.getStarredBeverages();
    int starDrinksCount = maxFabButtonsCount - 1;

    if (starBevs.length < starDrinksCount) starDrinksCount = starBevs.length;

    final widgets = List.generate(starDrinksCount, (idx) {
      final bev = starBevs[idx];
      return ExtendedFabButton(
          bev: bev, db: widget.db, notifyParent: widget.notifyParent);
    });

    // Add CustomDrinkButton in the middle
    widgets.insert(((starDrinksCount + 1) / 2).floor(),
        CustomDrinkButton(db: widget.db, notifyParent: widget.notifyParent));

    setState(() {
      _fabButtons = widgets;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FabCircularMenuPlus(
      animationDuration: const Duration(milliseconds: 500),
      alignment: Alignment.bottomCenter,
      fabSize: 70,
      ringDiameter: 400,
      ringWidth: 100,
      ringColor: Colors.transparent,
      fabColor: Theme.of(context).splashColor,
      fabOpenIcon: const Icon(Icons.add),
      children: _loading
          ? List.generate(
              maxFabButtonsCount, (idx) => const CircularProgressIndicator())
          : _fabButtons,
    );
  }
}

class CustomDrinkButton extends ExtendedFabButton {
  const CustomDrinkButton(
      {super.key, super.bev, required super.db, required super.notifyParent});

  _showCustomDrinkDialog() async {
    List<Beverage> beverages = await db.getBeverages();
    DrinksCompanion drink =
        await utils.GlobalNavigator.showAnimatedDialog(AddDrinkDialog(
      beverages: beverages,
      notifyParent: notifyParent,
    ));
    await db.insertOrUpdateDrink(drink);
    Beverage bev = await db.getBeverage(drink.bevID.value);

    showDrinkAddedSnackbar(drink, bev);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextButton(
          style: TextButton.styleFrom(
            shadowColor: Colors.black,
            elevation: 6,
            backgroundColor: Theme.of(context).primaryColor,
            shape: const CircleBorder(
                side: BorderSide(color: Colors.white, width: 2)),
          ),
          onPressed: _showCustomDrinkDialog,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.edit, color: Colors.black, size: ICONSIZE),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: ICONSIZE),
                  child: const Text("Custom",
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                )
              ],
            ),
          )),
    );
  }
}
