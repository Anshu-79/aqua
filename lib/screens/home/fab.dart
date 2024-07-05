import 'package:drift/drift.dart' as drift;
import 'package:fab_circular_menu_plus/fab_circular_menu_plus.dart';
import 'package:flutter/material.dart';

import 'package:aqua/notifications.dart';
import 'package:aqua/shared_pref_utils.dart';
import 'package:aqua/database/database.dart';
import 'package:aqua/dialog_boxes/add_drink.dart';
import 'package:aqua/icomoon_icons.dart';
import 'package:aqua/utils.dart' as utils;

const double iconSize = 45;

Future<void> showDrinkAddedSnackbar(DrinksCompanion drink, Beverage bev) async {
  String msg = "${drink.volume.value} mL of ${bev.name} added!";
  Color color = utils.toColor(bev.colorCode);

  utils.GlobalNavigator.showSnackBar(msg, color);
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
  final int maxFabButtonsCount = 4;
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
      animationDuration: const Duration(milliseconds: 300),
      alignment: Alignment.bottomCenter,
      fabSize: 70,
      ringDiameter: 425,
      ringWidth: 100,
      ringColor: Colors.transparent,
      fabColor: Theme.of(context).splashColor,
      fabOpenIcon: Icon(Icons.add, color: Theme.of(context).primaryColor),
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

    double waterVol = drink.volume.value * bev.waterPercent / 100;

    await db.updateConsumedVolume(waterVol.toInt());
    notifyParent();
    showDrinkAddedSnackbar(drink, bev);

    WaterGoal? todaysGoal = await db.getGoal(DateTime.now());
    int medianDrinkSize = await db.calcMedianDrinkSize();
    await NotificationsController.updateScheduledNotifications(
        todaysGoal!.reminderGap, medianDrinkSize);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextButton(
          style: TextButton.styleFrom(
            shadowColor: Colors.black,
            elevation: 6,
            backgroundColor: Theme.of(context).canvasColor,
            shape: const CircleBorder(
                side: BorderSide(color: Colors.white, width: 5)),
          ),
          onPressed: _showCustomDrinkDialog,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit,
                    color: Theme.of(context).primaryColor, size: iconSize),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: iconSize),
                  child: Text(
                    "Custom",
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                )
              ],
            ),
          )),
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
        datetime: drift.Value(DateTime.now()),
        datetimeOffset: drift.Value(await SharedPrefUtils.getWakeTime()));
    await db.insertOrUpdateDrink(drink);

    double waterVol = drink.volume.value * bev!.waterPercent / 100;

    await db.updateConsumedVolume(waterVol.toInt());
    notifyParent();

    showDrinkAddedSnackbar(drink, bev!);

    WaterGoal? todaysGoal = await db.getGoal(DateTime.now());
    int medianDrinkSize = await db.calcMedianDrinkSize();
    await NotificationsController.updateScheduledNotifications(
        todaysGoal!.reminderGap, medianDrinkSize);
  }

  @override
  Widget build(BuildContext context) {
    if (bev == null) return const SizedBox.shrink();

    Color color = utils.toColor(bev!.colorCode);
    return SizedBox(
      child: TextButton(
          style: TextButton.styleFrom(
            shadowColor: Colors.black,
            elevation: 6,
            backgroundColor: utils.lighten(color, 10),
            shape: CircleBorder(
                side: BorderSide(color: color, width: 5)),
          ),
          onPressed: _addQuickDrink,
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
