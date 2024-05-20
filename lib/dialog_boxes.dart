import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:aqua/utils.dart' as utils;

class AddWaterDialog extends StatefulWidget {
  const AddWaterDialog({super.key});

  @override
  State<AddWaterDialog> createState() => _AddWaterDialogState();
}

class _AddWaterDialogState extends State<AddWaterDialog> {
  int _currentValue = 200;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.only(top: 150),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
            side: BorderSide(width: 3, color: Theme.of(context).primaryColor)),
        backgroundColor: Theme.of(context).splashColor,
        surfaceTintColor: Colors.transparent,
        child: Container(
          alignment: Alignment.bottomCenter,
          height: 400,
          width: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(7),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                    backgroundColor: MaterialStateProperty.all(Colors.white)),
                child: Text(
                  "Water",
                  style: utils.ThemeText.dialogText,
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
                      value: _currentValue,
                      onChanged: (value) =>
                          setState(() => _currentValue = value)),
                  Text(
                    "mL",
                    style: utils.ThemeText.dialogText,
                  )
                ],
              ),
               Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    utils.addDrinkDialogButtons(icon: Icon(Icons.check), function:() => {},),
                    utils.addDrinkDialogButtons(icon: Icon(Icons.close), function: () => Navigator.of(context, rootNavigator: true).pop())
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
