import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils/widgets/time_picker.dart';
import 'package:aqua/utils/colors.dart';
import 'package:aqua/utils/widgets/global_navigator.dart';
import 'package:aqua/utils/widgets/dialog_action_button.dart';

class SleeptimeEditDialog extends StatefulWidget {
  const SleeptimeEditDialog(
      {super.key,
      required this.prefs,
      required this.notifyParent,
      required this.db});

  final SharedPreferences prefs;
  final Database db;
  final VoidCallback notifyParent;

  @override
  State<SleeptimeEditDialog> createState() => _SleeptimeEditDialogState();
}

class _SleeptimeEditDialogState extends State<SleeptimeEditDialog> {
  late int sleepTime;
  refresh(t) => setState(() => sleepTime = t);

  @override
  void initState() {
    sleepTime = widget.prefs.getInt('sleepTime') ?? 11;
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
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(Icons.bedtime, color: AquaColors.violet, size: 60),
            TimePicker(time: sleepTime, notifyParent: refresh),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DialogActionButton(
                    icon: const Icon(Icons.check),
                    function: () async {
                      int wakeTime = widget.prefs.getInt('wakeTime')!;
                      if (sleepTime != wakeTime) {
                        widget.prefs.setInt('sleepTime', sleepTime);
                        Navigator.pop(context);
                        widget.notifyParent();

                        // Update Daily goal to change reminder gap
                        await widget.db.updateConsumedVolume(0);
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
    );
  }
}
