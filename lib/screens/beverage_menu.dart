import 'package:aqua/icomoon_icons.dart';
import 'package:flutter/material.dart';
import 'package:aqua/utils.dart' as utils;

import 'package:aqua/database/database.dart';
import 'package:aqua/dialog_boxes/add_beverage.dart';
import 'package:aqua/dialog_boxes/edit_beverage.dart';

class BeverageMenu extends StatefulWidget {
  const BeverageMenu({super.key, required this.database});

  final Database database;

  @override
  State<BeverageMenu> createState() => _BeverageMenuState();
}

class _BeverageMenuState extends State<BeverageMenu> {
  refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const utils.UniversalHeader(title: "My Beverages"),
      body: FutureBuilder<List<Beverage>>(
          future: widget.database.getBeverages(),
          builder: (context, snapshot) {
            final List<Beverage> beverages = snapshot.data ?? [];

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            return ListView.builder(
                itemCount: beverages.length,
                itemBuilder: (context, index) {
                  return BeverageCard(
                    bvg: beverages[index],
                    db: widget.database,
                    notifyParent: refresh,
                  );
                });
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            tooltip: "Add new beverage",
            backgroundColor: Theme.of(context).primaryColor,
            splashColor: Theme.of(context).splashColor,
            shape: const CircleBorder(eccentricity: 0),
            onPressed: () async {
              final output = await utils.GlobalNavigator.showAnimatedDialog(
                  AddBeverageDialog(notifyParent: refresh));

              BeveragesCompanion? addedBeverage = output[1];

              if (addedBeverage == null) return;

              List<Beverage> bevList = await widget.database.getBeverages();
              List<String> names = bevList.map((bev) => bev.name).toList();

              if (names.contains(addedBeverage.name.value)) {
                utils.GlobalNavigator.showSnackBar(
                    'This beverage already exists', null);
              } else {
                utils.GlobalNavigator.showSnackBar('Beverage Added',
                    utils.toColor(addedBeverage.colorCode.value));
                await widget.database.insertOrUpdateBeverage(addedBeverage);
              }
            },
            child:
                Icon(Icons.add, color: Theme.of(context).canvasColor, size: 50),
          )),
    );
  }
}

class BeverageCard extends StatefulWidget {
  const BeverageCard(
      {super.key,
      required this.bvg,
      required this.db,
      required this.notifyParent});
  final Beverage bvg;
  final Database db;
  final VoidCallback notifyParent;

  @override
  State<BeverageCard> createState() => _BeverageCardState();
}

class _BeverageCardState extends State<BeverageCard> {
  late bool starred;

  refresh() => setState(() {});

  @override
  void initState() {
    starred = widget.bvg.starred;
    super.initState();
  }

  void _conditionalActions(Beverage bvg) async {
    // Prevent changes to Water
    if (bvg.id == 1) {
      return utils.GlobalNavigator.showSnackBar(
          '${bvg.name} cannot be edited', utils.toColor(bvg.colorCode));
    }

    List? output = await utils.GlobalNavigator.showAnimatedDialog(
        EditBeverageDialog(notifyParent: refresh, beverage: widget.bvg));

    String choice = output![0];

    if (choice == 'delete') {
      utils.GlobalNavigator.showSnackBar('Beverage Deleted', null);
      await widget.db.deleteBeverage(bvg.id);
      widget.notifyParent();
    } else if (choice == 'edit') {
      BeveragesCompanion? updatedBev = output[1];

      List<Beverage> bevList = await widget.db.getBeverages();
      List<String> names = bevList.map((bev) => bev.name).toList();

      // Checks if a beverage of the same name exists
      bool bevNameAlreadyExists = names.contains(updatedBev!.name.value);

      // Checks if it is the same beverage as the one being edited
      bool sameBev = bvg.name == updatedBev.name.value;

      if (bevNameAlreadyExists && !sameBev) {
        return utils.GlobalNavigator.showSnackBar(
            "This beverage already exists", null);
      }

      await widget.db.insertOrUpdateBeverage(updatedBev);
      widget.notifyParent();
      return utils.GlobalNavigator.showSnackBar(
          'Beverage Edited', utils.toColor(updatedBev.colorCode.value));
    }
  }

  Icon _beverageIcon() {
    return Icon(Icomoon.water_glass_pixelart,
        color: utils.toColor(widget.bvg.colorCode), size: 60);
  }

  Text bevNameText() {
    return Text(
      widget.bvg.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: utils.ThemeText.beverageName,
    );
  }

  Icon filledStarIcon = const Icon(Icons.star, color: Colors.amber, size: 40);
  Icon blankStarIcon =
      const Icon(Icons.star_border, color: Colors.amber, size: 40);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => _conditionalActions(widget.bvg),
      child: Card(
          elevation: 0,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
          color: utils.toColor(widget.bvg.colorCode).withOpacity(0.3),
          shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              side: BorderSide(
                  color: utils.toColor(widget.bvg.colorCode), width: 5)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _beverageIcon(),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      bevNameText(),
                      Text("Water Percentage",
                          style: utils.ThemeText.beverageSubtext),
                      Text('${widget.bvg.waterPercent.toString()}%',
                          style: utils.ThemeText.beverageWaterPercentage),
                    ],
                  ),
                ),
                IconButton(
                  icon: starred ? filledStarIcon : blankStarIcon,
                  onPressed: () {
                    widget.db.toggleBeverageStar(widget.bvg.id, starred);
                    setState(() => starred = !starred);
                  },
                ),
              ],
            ),
          )),
    );
  }
}
