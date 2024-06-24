import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:numberpicker/numberpicker.dart';

import 'package:aqua/utils.dart' as utils;
import 'package:aqua/database/database.dart';

class CustomizeWorkout extends StatefulWidget {
  const CustomizeWorkout({super.key, required this.activity});
  final Activity? activity;

  @override
  State<CustomizeWorkout> createState() => _CustomizeWorkoutState();
}

class _CustomizeWorkoutState extends State<CustomizeWorkout> {
  int _duration = 20;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: utils.getWorkoutColor(widget.activity!.id),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
          side: BorderSide(width: 5, color: Theme.of(context).primaryColor)),
      surfaceTintColor: Colors.transparent,
      child: SizedBox(
        height: 475,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                utils.getWorkoutIcon(widget.activity!.id),
                size: 60,
              ),
              FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    widget.activity!.category,
                    style: utils.ThemeText.workoutTitle,
                  )),
              Text(
                widget.activity!.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NumberPicker(
                      itemHeight: 60,
                      itemWidth: 120,
                      selectedTextStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 50),
                      textStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                      axis: Axis.vertical,
                      minValue: 10,
                      step: 5,
                      maxValue: 300,
                      value: _duration,
                      onChanged: (value) => setState(() => _duration = value)),
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      "minutes",
                      style: utils.ThemeText.durationSubtext,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  utils.addDrinkDialogButtons(
                    icon: const Icon(Icons.check),
                    function: () {
                      final workout = WorkoutsCompanion(
                        activityID: drift.Value(widget.activity!.id),
                        datetime: drift.Value(DateTime.now()),
                        duration: drift.Value(_duration),
                      );
                      Navigator.pop(context, workout);
                      utils.GlobalNavigator.showSnackBar("Activity Added",
                          utils.getWorkoutColor(widget.activity!.id));
                    },
                  ),
                  utils.addDrinkDialogButtons(
                      icon: const Icon(Icons.close),
                      function: () => Navigator.pop(context))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
