import 'package:aqua/utils/shared_pref_utils.dart';
import 'package:aqua/intake_calculations.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:numberpicker/numberpicker.dart';

import 'package:aqua/utils/widgets/dialog_action_button.dart';
import 'package:aqua/utils/widgets/global_navigator.dart';
import 'package:aqua/database/database.dart';
import 'package:aqua/screens/activity_menu/helpers.dart';

/// This dialog is displayed when an [Activity] is clicked on [AddWorkoutDialog]
/// Its primary objective is to set [Workout.duration]
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
      backgroundColor: getWorkoutColor(widget.activity!.id),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
          side: BorderSide(width: 5, color: Theme.of(context).primaryColor)),
      child: Container(
        padding: const EdgeInsets.all(15),
        height: 475,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(getWorkoutIcon(widget.activity!.id), size: 60),
            FittedBox(
                fit: BoxFit.contain,
                child: Text(widget.activity!.category,
                    style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Colors.black))),
            Text(widget.activity!.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NumberPicker(
                    itemHeight: 60,
                    itemWidth: 120,
                    selectedTextStyle: const TextStyle(
                        color: Colors.black,
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
                const FittedBox(
                    fit: BoxFit.contain,
                    child: Text("minutes",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Colors.white)))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DialogActionButton(
                  icon: const Icon(Icons.check),
                  function: () async {
                    double swl =
                        await calcSweatLoss(widget.activity!.met, _duration);

                    // Generating a [WorkoutsCompanion] for the workout to be added
                    final workout = WorkoutsCompanion(
                      activityID: drift.Value(widget.activity!.id),
                      datetime: drift.Value(DateTime.now()),
                      duration: drift.Value(_duration),
                      waterLoss: drift.Value(swl.toInt()),
                      datetimeOffset:
                          drift.Value(await SharedPrefUtils.getWakeTime()),
                    );

                    if (context.mounted) Navigator.pop(context, workout);

                    GlobalNavigator.showSnackBar(
                        "Activity Added", getWorkoutColor(widget.activity!.id));
                  },
                ),
                DialogActionButton(
                    icon: const Icon(Icons.close),
                    function: () => Navigator.pop(context))
              ],
            )
          ],
        ),
      ),
    );
  }
}
