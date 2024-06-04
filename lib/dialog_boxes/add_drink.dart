import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:numberpicker/numberpicker.dart';

import 'package:aqua/utils.dart' as utils;
import 'package:aqua/database/database.dart';
import 'package:aqua/dialog_boxes/show_beverages.dart';

class AddWaterDialog extends StatefulWidget {
  const AddWaterDialog({super.key});

  @override
  State<AddWaterDialog> createState() => _AddWaterDialogState();
}

class _AddWaterDialogState extends State<AddWaterDialog> {
  Beverage _selectedBeverage = Beverage(
      bevID: 1,
      bevName: "Water",
      colorCode: utils.toHexString(utils.defaultColors['blue']!),
      waterPercent: 100);

  int _volume = 200;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.only(top: 150),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
            side: BorderSide(width: 5, color: Theme.of(context).primaryColor)),
        backgroundColor: utils.toColor(_selectedBeverage.colorCode),
        surfaceTintColor: Colors.transparent,
        child: Container(
          alignment: Alignment.bottomCenter,
          height: 400,
          width: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Tooltip(
                  message: _selectedBeverage.bevName,
                  child: ElevatedButton(
                    onPressed: () async {
                      Beverage? val = await showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return const ListBeverages();
                          });

                      setState(() {
                        _selectedBeverage = val!;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 7,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Colors.white),
                    child: Text(
                      _selectedBeverage.bevName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: utils.ThemeText.dialogText,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NumberPicker(
                      itemHeight: 60,
                      itemWidth: 120,
                      selectedTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 50),
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                      axis: Axis.vertical,
                      minValue: 25,
                      step: 25,
                      maxValue: 1000,
                      value: _volume,
                      onChanged: (value) => setState(() => _volume = value)),
                  Text(
                    "mL",
                    style: utils.ThemeText.dialogText,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    utils.addDrinkDialogButtons(
                      icon: const Icon(Icons.check),
                      function: () {
                        final drink = DrinksCompanion(
                            bevID: drift.Value(_selectedBeverage.bevID),
                            volume: drift.Value(_volume),
                            datetime: drift.Value(DateTime.now()));
                        Navigator.pop(context, drink);
                      },
                    ),
                    utils.addDrinkDialogButtons(
                        icon: const Icon(Icons.close),
                        function: () =>
                            Navigator.of(context, rootNavigator: true).pop())
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
