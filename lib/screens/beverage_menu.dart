import 'package:aqua/icomoon_icons.dart';
import 'package:flutter/material.dart';
import 'package:aqua/utils.dart' as utils;

import 'package:aqua/database/database.dart';
import 'package:aqua/dialog_boxes/add_beverage.dart';
import 'package:aqua/dialog_boxes/edit_beverage.dart';

class BeverageMenu extends StatefulWidget {
  const BeverageMenu({super.key});

  @override
  State<BeverageMenu> createState() => _BeverageMenuState();
}

class _BeverageMenuState extends State<BeverageMenu> {
  late Database _db;

  Color screenTheme = utils.defaultColors['red']!;

  refresh() => setState(() {});

  @override
  void initState() {
    super.initState();
    //print("Beverage page loaded...");
    _db = Database();
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }

  void showDefaultBevSnackBar(Color color) {
    final snackbar = SnackBar(
      content: const Text(
        "Changes cannot be made to Water",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: AppBar(
            surfaceTintColor: Theme.of(context).canvasColor,
            backgroundColor: Theme.of(context).canvasColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
                side: BorderSide.none, borderRadius: BorderRadius.circular(25)),
            centerTitle: true,
            titleTextStyle: utils.ThemeText.screenHeader,
            title: Padding(
              padding: const EdgeInsets.only(bottom: 30, top: 20),
              child: Text("My Beverages",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontFamily: "CeraPro")),
            ),
            foregroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: FutureBuilder<List<Beverage>>(
            future: _db.getBeverages(),
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
              }

              else {
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
                                await _db.insertOrUpdateBeverage(output[1]);
                              } else if (output[0] == 1) {
                                await _db.deleteBeverage(output[1]);
                              }
                            } else {
                              showDefaultBevSnackBar(
                                  utils.toColor(beverage.colorCode));
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
      ),
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
            await _db.insertOrUpdateBeverage(addedBeverage!);
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
