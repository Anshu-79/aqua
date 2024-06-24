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

            //print(beverages);
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return ListView.builder(
                  itemCount: beverages.length,
                  itemBuilder: (context, index) {
                    final beverage = beverages[index];
                    return Card(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                      elevation: 0,
                      color: utils.toColor(beverage.colorCode).withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          side: BorderSide(
                              color: utils.toColor(beverage.colorCode),
                              width: 5)),
                      child: ListTile(
                        onTap: () async {
                          if (beverage.id != 1) {
                            List? output =
                                await utils.GlobalNavigator.showAnimatedDialog(
                                    EditBeverageDialog(
                                        notifyParent: refresh,
                                        beverage: beverage));

                            if (output![0] == 0) {
                              List<Beverage> bevList =
                                  await widget.database.getBeverages();
                              List<String> names =
                                  bevList.map((bev) => bev.name).toList();

                              if (names.contains(output[1].name.value) &&
                                  beverage.name != output[1].name.value) {
                                utils.GlobalNavigator.showSnackBar(
                                    "This beverage already exists", null);
                              } else {
                                BeveragesCompanion beverage = output[1];

                                await widget.database
                                    .insertOrUpdateBeverage(beverage);
                                utils.GlobalNavigator.showSnackBar(
                                    'Beverage Edited',
                                    utils.toColor(beverage.colorCode.value));
                              }
                            } else if (output[0] == 1) {
                              utils.GlobalNavigator.showSnackBar(
                                  'Beverage Deleted', null);
                              await widget.database.deleteBeverage(output[1]);
                            }
                          } else {
                            utils.GlobalNavigator.showSnackBar(
                                '${beverage.name} cannot be edited',
                                utils.toColor(beverage.colorCode));
                          }
                        },
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        splashColor: utils.toColor(beverage.colorCode),
                        title: BeverageCard(
                          beverage: beverage,
                          db: widget.database,
                        ),
                      ),
                    );
                  });
            }
          }),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: () async {
            BeveragesCompanion? addedBeverage =
                await utils.GlobalNavigator.showAnimatedDialog(
                    AddBeverageDialog(notifyParent: refresh));

            List<Beverage> bevList = await widget.database.getBeverages();
            List<String> names = bevList.map((bev) => bev.name).toList();

            if (names.contains(addedBeverage!.name.value)) {
              utils.GlobalNavigator.showSnackBar(
                  'This beverage already exists', null);
            } else {
              utils.GlobalNavigator.showSnackBar('Beverage Added',
                  utils.toColor(addedBeverage.colorCode.value));
              await widget.database.insertOrUpdateBeverage(addedBeverage);
            }
          },
          tooltip: "Add new beverage",
          backgroundColor: Theme.of(context).primaryColor,
          splashColor: Theme.of(context).splashColor,
          shape: const CircleBorder(eccentricity: 0),
          child: Icon(
            Icons.add,
            color: Theme.of(context).canvasColor,
            size: 50,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class BeverageCard extends StatefulWidget {
  const BeverageCard({super.key, required this.beverage, required this.db});
  final Beverage beverage;
  final Database db;

  @override
  State<BeverageCard> createState() => _BeverageCardState();
}

class _BeverageCardState extends State<BeverageCard> {
  late bool starred;

  @override
  void initState() {
    starred = widget.beverage.starred;
    super.initState();
  }

  Icon beverageIcon({required Color color}) {
    return Icon(Icomoon.water_glass_pixelart, color: color, size: 60);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
                beverageIcon(color: utils.toColor(widget.beverage.colorCode))),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.beverage.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: utils.ThemeText.beverageName,
                  ),
                  IconButton(
                    icon: starred
                        ? const Icon(Icons.star, color: Colors.amber)
                        : const Icon(Icons.star_border, color: Colors.amber),
                    onPressed: () {
                      widget.db.toggleBeverageStar(widget.beverage.id, starred);
                      setState(() => starred = !starred);
                    },
                  )
                ],
              ),
              Text(
                "Water Percentage",
                style: utils.ThemeText.beverageSubtext,
              ),
              Text(
                '${widget.beverage.waterPercent.toString()}%',
                style: utils.ThemeText.beverageWaterPercentage,
              ),
            ],
          ),
        )
      ],
    );
  }
}
