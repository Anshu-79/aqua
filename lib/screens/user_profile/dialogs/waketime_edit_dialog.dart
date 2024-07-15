import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/utils/colors.dart';
import 'package:aqua/utils/widgets/time_picker.dart';
import 'package:aqua/utils/widgets/dialog_action_button.dart';
import 'package:aqua/utils/widgets/global_navigator.dart';
import 'package:aqua/database/database.dart';

/// This widget uses [TimePicker] to edit the waking time of user
class WaketimeEditDialog extends StatefulWidget {
  const WaketimeEditDialog(
      {super.key,
      required this.prefs,
      required this.notifyParent,
      required this.db});

  final SharedPreferences prefs;
  final Database db;
  final VoidCallback notifyParent;

  @override
  State<WaketimeEditDialog> createState() => _WaketimeEditDialogState();
}

class _WaketimeEditDialogState extends State<WaketimeEditDialog> {
  late int wakeTime;
  refresh(t) => setState(() => wakeTime = t);

  @override
  void initState() {
    wakeTime = widget.prefs.getInt('wakeTime') ?? 8;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    Color canvasColor = Theme.of(context).canvasColor;

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
          side: BorderSide(color: primaryColor, width: 3)),
      backgroundColor: canvasColor,
      child: AspectRatio(
        aspectRatio: 0.7,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.sunny, color: AquaColors.yellow, size: 60),
              TimePicker(time: wakeTime, notifyParent: refresh),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DialogActionButton(
                      icon: const Icon(Icons.check),
                      function: () async {
                        int sleepTime = widget.prefs.getInt('sleepTime')!;
                        if (sleepTime != wakeTime) {
                          widget.prefs.setInt('wakeTime', wakeTime);
                          Navigator.pop(context);
                          widget.notifyParent();
        
                          // Update Daily goal to change reminder gap
                          await widget.db.setTodaysGoal();
                        } else {
                          GlobalNavigator.showSnackBar(
                              'Sleeping Time & Wake-up Time cannot be same',
                              AquaColors.red);
                        }
                      }),
                  DialogActionButton(
                    icon: const Icon(Icons.close),
                    function: () => Navigator.pop(context),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
