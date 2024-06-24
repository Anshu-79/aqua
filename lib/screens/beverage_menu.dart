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

  void showBevMenuSnackBar(Color color, String text) {
    final snackbar = utils.coloredSnackBar(color, text);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

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
                      color:
                          utils.toColor(beverage.colorCode).withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          side: BorderSide(
                              color: utils.toColor(beverage.colorCode),
                              width: 5)),
                      child: ListTile(
                        onTap: () async {
                          if (beverage.bevID != 1) {
                            List? output = await showGeneralDialog(
                                barrierDismissible: false,
                                transitionDuration:
                                    const Duration(milliseconds: 150),
                                transitionBuilder: (context, a1, a2, child) {
                                  return ScaleTransition(
                                      scale:
                                          Tween<double>(begin: 0.5, end: 1.0)
                                              .animate(a1),
                                      child: FadeTransition(
                                        opacity: Tween<double>(
                                                begin: 0.5, end: 1.0)
                                            .animate(a1),
                                        child: EditBeverageDialog(
                                          beverage: beverage,
                                          notifyParent: refresh,
                                        ),
                                      ));
                                },
                                context: context,
                                pageBuilder: (context, a1, a2) {
                                  return const Placeholder();
                                });
      
                            if (output![0] == 0) {
                              List<Beverage> bevList =
                                  await widget.database.getBeverages();
                              List<String> bevNames =
                                  bevList.map((bev) => bev.bevName).toList();
      
                              if (bevNames
                                      .contains(output[1].bevName.value) &&
                                  beverage.bevName !=
                                      output[1].bevName.value) {
                                showBevMenuSnackBar(
                                    Theme.of(context).primaryColor,
                                    'This beverage already exists');
                              } else {
                                BeveragesCompanion beverage = output[1];
                                showBevMenuSnackBar(
                                    utils.toColor(beverage.colorCode.value),
                                    'Beverage Edited');
                                await widget.database
                                    .insertOrUpdateBeverage(beverage);
                              }
                            } else if (output[0] == 1) {
                              showBevMenuSnackBar(
                                  Theme.of(context).primaryColor,
                                  'Beverage Deleted');
                              await widget.database.deleteBeverage(output[1]);
                            }
                          } else {
                            showBevMenuSnackBar(
                                utils.toColor(beverage.colorCode),
                                '${beverage.bevName} cannot be edited');
                          }
                        },
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        splashColor: utils.toColor(beverage.colorCode),
                        title: _BeverageCard(
                            beverageName: beverage.bevName,
                            beverageColor: beverage.colorCode,
                            waterFraction: beverage.waterPercent),
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
            BeveragesCompanion? addedBeverage = await showGeneralDialog(
                barrierDismissible: false,
                transitionDuration: const Duration(milliseconds: 150),
                transitionBuilder: (context, a1, a2, child) {
                  return ScaleTransition(
                      scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                      child: FadeTransition(
                        opacity:
                            Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                        child: AddBeverageDialog(
                          notifyParent: refresh,
                        ),
                      ));
                },
                context: context,
                pageBuilder: (context, a1, a2) {
                  return const Placeholder();
                });
            List<Beverage> bevList = await widget.database.getBeverages();
            List<String> bevNames = bevList.map((bev) => bev.bevName).toList();

            if (bevNames.contains(addedBeverage!.bevName.value)) {
              showBevMenuSnackBar(Theme.of(context).primaryColor,
                  'This beverage already exists');
            } else {
              showBevMenuSnackBar(utils.toColor(addedBeverage.colorCode.value),
                  'Beverage Added');
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

class _BeverageCard extends StatelessWidget {
  const _BeverageCard(
      {required this.beverageName,
      required this.beverageColor,
      required this.waterFraction});
  final String beverageName;
  final String beverageColor;
  final int waterFraction;

  Icon beverageIcon({required Color color}) {
    return Icon(Icomoon.water_glass_pixelart, color: color, size: 60);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: beverageIcon(color: utils.toColor(beverageColor))),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                beverageName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: utils.ThemeText.beverageName,
              ),
              Text(
                "Water Percentage",
                style: utils.ThemeText.beverageSubtext,
              ),
              Text(
                '${waterFraction.toString()}%',
                style: utils.ThemeText.beverageWaterPercentage,
              ),
            ],
          ),
        )
      ],
    );
  }
}
