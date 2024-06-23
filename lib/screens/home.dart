import 'package:flutter/material.dart';

import 'package:aqua/water_animation.dart';
import 'package:aqua/utils.dart' as utils;
import 'package:aqua/expandable_fab.dart' as fab;
import 'package:aqua/icomoon_icons.dart';
import 'package:aqua/dialog_boxes/edit_drink.dart';
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          surfaceTintColor: Theme.of(context).canvasColor,
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
              side: BorderSide.none, borderRadius: BorderRadius.circular(25)),
          centerTitle: true,
          titleTextStyle: utils.ThemeText.screenHeader,
          title: Text("Today's Goal",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: "CeraPro")),
          foregroundColor: Theme.of(context).primaryColor,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 425,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 4, color: Theme.of(context).primaryColor),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(35))),
                  child: WaterGoalWidget(
                    fillValue: 0.5,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(35, 10, 35, 10),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              utils.borderedText(
                                  "1.50",
                                  utils.ThemeText.dailyGoalConsumed,
                                  utils.ThemeText.dailyGoalBorder),
                              Text.rich(TextSpan(
                                text: " L",
                                style: utils.ThemeText.dailyGoalFillerText,
                              )),
                            ],
                          ),
                          Text(
                            "of",
                            style: utils.ThemeText.dailyGoalFillerText,
                          ),
                          Row(
                            children: [
                              utils.borderedText(
                                  "3.00",
                                  utils.ThemeText.dailyGoalTotal,
                                  utils.ThemeText.dailyGoalBorder),
                              Text.rich(TextSpan(
                                text: " L",
                                style: utils.ThemeText.dailyGoalFillerText,
                              )),
                            ],
                          ),
                          Text(
                            "consumed",
                            style: utils.ThemeText.dailyGoalFillerText,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 4, color: Theme.of(context).primaryColor),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.5, bottom: 2.5),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 5, right: 10),
                          child: Icon(
                            Icons.alarm,
                            size: 60,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Next reminder in",
                              style: utils.ThemeText.reminderSubText,
                            ),
                            Text(
                              "20 minutes",
                              style: utils.ThemeText.reminderText,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: fab.ExpandableFab(
        notifyParent: refresh,
        distance: 75,
        children: [
          fab.ActionButton(
            onPressed: () {},
            icon:
                Icon(Icomoon.coffee_cup, color: Theme.of(context).canvasColor),
            editDialogBox: editDrinkDialogBox(),
          ),
          fab.ActionButton(
            onPressed: () {},
            icon:
                Icon(Icomoon.water_glass, color: Theme.of(context).canvasColor),
            editDialogBox: editDrinkDialogBox(),
          ),
          fab.ActionButton(
            onPressed: () {},
            icon: Icon(Icomoon.soda_can, color: Theme.of(context).canvasColor),
            editDialogBox: editDrinkDialogBox(),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
