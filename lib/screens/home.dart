import 'package:flutter/material.dart';

import 'package:aqua/utils.dart' as utils;
import 'package:aqua/expandable_fab.dart' as fab;
import 'package:aqua/icomoon_icons.dart';
import 'package:aqua/dialog_boxes/edit_drink.dart';
import 'package:aqua/database/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Database _db;

  refresh() => setState(() {});

  @override
  void initState() {
    _db = Database();
    super.initState();
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50, bottom: 30),
              child: Text(
                "Today's Goal",
                style: utils.ThemeText.screenHeader,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 4, color: Theme.of(context).primaryColor),
                  borderRadius: const BorderRadius.all(Radius.circular(35))),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(35, 10, 35, 10),
                child: Column(
                  children: [
                    Stack(children: [
                      Text.rich(TextSpan(children: [
                        TextSpan(
                          text: "1.50",
                          style: utils.ThemeText.dailyGoalBorder,
                        ),
                        TextSpan(
                          text: " L",
                          style: utils.ThemeText.dailyGoalFillerText,
                        )
                      ])),
                      Text.rich(TextSpan(children: [
                        TextSpan(
                          text: "1.50",
                          style: utils.ThemeText.dailyGoalConsumed,
                        ),
                        TextSpan(
                          text: " L",
                          style: utils.ThemeText.dailyGoalFillerText,
                        )
                      ])),
                    ]),
                    Text(
                      "of",
                      style: utils.ThemeText.dailyGoalFillerText,
                    ),
                    Stack(
                      children: [
                        Text.rich(TextSpan(children: [
                          TextSpan(
                            text: "3.00",
                            style: utils.ThemeText.dailyGoalBorder,
                          ),
                          TextSpan(
                            text: " L",
                            style: utils.ThemeText.dailyGoalFillerText,
                          )
                        ])),
                        Text.rich(TextSpan(children: [
                          TextSpan(
                            text: "3.00",
                            style: utils.ThemeText.dailyGoalTotal,
                          ),
                          TextSpan(
                            text: " L",
                            style: utils.ThemeText.dailyGoalFillerText,
                          )
                        ])),
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
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Container(
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 4, color: Theme.of(context).primaryColor),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
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
