import 'package:flutter/material.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils/colors.dart';
import 'package:aqua/utils/icomoon_icons.dart';
import 'package:aqua/utils/widgets/blank_screen.dart';
import 'package:aqua/utils/widgets/universal_header.dart';
import 'package:aqua/utils/widgets/global_navigator.dart';

class TodaysDrinksDialog extends StatefulWidget {
  const TodaysDrinksDialog({super.key, required this.db});

  final Database db;

  @override
  State<TodaysDrinksDialog> createState() => _TodaysDrinksDialogState();
}

class _TodaysDrinksDialogState extends State<TodaysDrinksDialog> {
  void refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    Color canvasColor = Theme.of(context).canvasColor;

    return Scaffold(
      backgroundColor: canvasColor,
      appBar: const UniversalHeader(title: "Today's Drinks"),
      body: AspectRatio(
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
                    final drinks = todaysDrinks.keys.toList().reversed;
                    Drink drink = drinks.toList()[index];

                    return DrinkCard(
                        drink: drink,
                        beverage: todaysDrinks[drink]!,
                        db: widget.db,
                        notifyParent: refresh);
                  });
            } else {
              String blankText = "No drinks logged today.\nTry adding one!";
              return BlankScreen(message: blankText);
            }
          },
        ),
      ),
    );
  }
}

class DrinkCard extends StatelessWidget {
  const DrinkCard(
      {super.key,
      required this.drink,
      required this.beverage,
      required this.db,
      required this.notifyParent});
  final Database db;
  final Drink drink;
  final Beverage beverage;
  final VoidCallback notifyParent;

  @override
  Widget build(BuildContext context) {
    Color bevColor = beverage.colorCode.toColor();
    TimeOfDay drinkTime = TimeOfDay.fromDateTime(drink.datetime);
    String drinkTimeText = getTimeInText(drinkTime.hour, drinkTime.minute);

    TextStyle volStyle =
        const TextStyle(fontSize: 20, fontWeight: FontWeight.w900);
    TextStyle nameStyle =
        TextStyle(fontSize: 45, fontWeight: FontWeight.w900, color: bevColor);
    TextStyle timeStyle =
        const TextStyle(fontSize: 25, fontWeight: FontWeight.bold);

    return Card(
        elevation: 0,
        margin: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        color: bevColor.withOpacity(0.2),
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            side: BorderSide(color: bevColor, width: 5)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        Icon(Icomoon.water_glass_pixelart,
                            color: bevColor, size: 60),
                        const SizedBox(height: 10),
                        Text('${drink.volume.toString()} mL', style: volStyle),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(beverage.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: nameStyle),
                        Text(drinkTimeText, style: timeStyle)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            deleteButton(Theme.of(context).primaryColor),
          ],
        ));
  }

  Widget deleteButton(Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, top: 10),
      child: Align(
        alignment: Alignment.bottomRight,
        child: IconButton(
          icon: Icon(Icons.delete_rounded, size: 50, color: color),
          style: IconButton.styleFrom(),
          onPressed: () async => removeDrink(db, drink, beverage, notifyParent),
        ),
      ),
    );
  }
}

Future<void> removeDrink(
    Database db, Drink drink, Beverage bev, VoidCallback refreshScreen) async {
  int volume = drink.volume;
  int hydrationVol = volume * bev.waterPercent ~/ 100;
  await db.deleteDrink(drink.id);
  await db.updateConsumedVolume(-hydrationVol);
  GlobalNavigator.showSnackBar("${bev.name} deleted!", bev.colorCode.toColor());
  refreshScreen();
}

String getTimeInText(int hour, int minute) {
  String mins = "$minute";
  if (minute < 10) mins = "0$minute";

  if (hour > 12) return "${hour - 12}:$mins PM";
  if (hour == 12) return "12:$mins PM";
  return "$hour:$mins AM";
}
