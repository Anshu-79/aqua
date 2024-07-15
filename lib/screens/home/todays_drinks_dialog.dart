import 'package:aqua/utils/icomoon_icons.dart';
import 'package:aqua/utils/textstyles.dart';
import 'package:aqua/utils/widgets/blank_screen.dart';
import 'package:flutter/material.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils/colors.dart';
import 'package:aqua/utils/widgets/global_navigator.dart';

void showTodaysDrinksDialog(Database db, Function(double) fillAnimation) =>
    GlobalNavigator.showAnimatedDialog(
        TodaysDrinksDialog(db: db, fillAnimation: fillAnimation));

class TodaysDrinksDialog extends StatefulWidget {
  const TodaysDrinksDialog(
      {super.key, required this.db, required this.fillAnimation});

  final Database db;
  final Function(double) fillAnimation;

  @override
  State<TodaysDrinksDialog> createState() => _TodaysDrinksDialogState();
}

class _TodaysDrinksDialogState extends State<TodaysDrinksDialog> {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    Color canvasColor = Theme.of(context).canvasColor;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 7.5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
          side: BorderSide(color: primaryColor, width: 3)),
      backgroundColor: canvasColor,
      child: AspectRatio(
          aspectRatio: 0.5,
          child: FutureBuilder(
              future: widget.db.getTodaysDrinks(),
              builder: (context, snapshot) {
                Map<Drink, Beverage>? todaysDrinks = snapshot.data;

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                if (todaysDrinks != null && todaysDrinks.isNotEmpty) {
                  return ListView.builder(
                      itemCount: todaysDrinks.length,
                      itemBuilder: (context, index) {
                        Drink drink = todaysDrinks.keys.toList()[index];

                        return DrinkCard(
                            drink: drink, beverage: todaysDrinks[drink]!);
                      });
                } else {
                  return const BlankScreen(
                      message: "No drinks logged today.\nTry adding one!");
                }
              })),
    );
  }
}

class DrinkCard extends StatelessWidget {
  const DrinkCard({super.key, required this.drink, required this.beverage});
  final Drink drink;
  final Beverage beverage;

  @override
  Widget build(BuildContext context) {
    Color bevColor = beverage.colorCode.toColor();

    return Card(
        elevation: 0,
        margin: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        color: bevColor.withOpacity(0.2),
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            side: BorderSide(color: bevColor, width: 5)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icomoon.water_glass_pixelart, color: bevColor, size: 60),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(beverage.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: BeverageMenuStyles.nameStyle),
                    Text('${drink.volume.toString()} mL',
                        style: BeverageMenuStyles.waterPercentStyle),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                // style: IconButton.styleFrom(
                //     backgroundColor:
                //         starred ? Colors.white : Colors.transparent),
                onPressed: () {},
              ),
            ],
          ),
        ));
  }
}
