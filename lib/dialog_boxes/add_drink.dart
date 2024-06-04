import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:numberpicker/numberpicker.dart';

import 'package:aqua/utils.dart' as utils;
import 'package:aqua/database/database.dart';

class AddWaterDialog extends StatefulWidget {
  const AddWaterDialog(
      {super.key, required this.beverages, required this.notifyParent});

  final List<Beverage> beverages;
  final Function notifyParent;

  @override
  State<AddWaterDialog> createState() => _AddWaterDialogState();
}

class _AddWaterDialogState extends State<AddWaterDialog> {
  int _bevIndex = 0;
  int _volume = 200;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.only(top: 150),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
            side: BorderSide(width: 5, color: Theme.of(context).primaryColor)),
        backgroundColor: utils.toColor(widget.beverages[_bevIndex].colorCode),
        surfaceTintColor: Colors.transparent,
        child: Container(
          alignment: Alignment.bottomCenter,
          height: 400,
          width: 150,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                            padding: const EdgeInsets.only(left: 10),
                            color: Colors.black,
                            onPressed: () {
                              if (_bevIndex == 0) {
                                setState(() =>
                                    (_bevIndex = widget.beverages.length - 1));
                              } else {
                                setState(() => _bevIndex -= 1);
                              }
                            },
                            icon: const Icon(Icons.arrow_back_ios)),
                      ),
                      SizedBox(
                        width: 150,
                        height: 80,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                widget.beverages[_bevIndex].bevName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: utils.ThemeText.addDrinkBeverageName,
                              ),
                            ),
                          ),
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                            color: Colors.black,
                            onPressed: () {
                              if (_bevIndex == widget.beverages.length - 1) {
                                setState(() => _bevIndex = 0);
                              } else {
                                setState(() => _bevIndex += 1);
                              }
                            },
                            icon: const Icon(Icons.arrow_forward_ios)),
                      ),
                    ],
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
                      style: utils.ThemeText.addDrinkDialogText,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    utils.addDrinkDialogButtons(
                      icon: const Icon(Icons.check),
                      function: () {
                        final drink = DrinksCompanion(
                            bevID:
                                drift.Value(widget.beverages[_bevIndex].bevID),
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
                )
              ],
            ),
          ),
        ));
  }
}
