import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/utils/time_picker.dart';
import 'package:aqua/utils.dart' as utils;

class WaketimeEditDialog extends StatefulWidget {
  const WaketimeEditDialog(
      {super.key, required this.prefs, required this.notifyParent});

  final SharedPreferences prefs;
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
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.sunny, color: utils.defaultColors['yellow'], size: 60),
            TimePicker(time: wakeTime, notifyParent: refresh),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                utils.DialogActionButton(
                    icon: const Icon(Icons.check),
                    function: () async {
                      widget.prefs.setInt('wakeTime', wakeTime);
                      Navigator.pop(context);
                      widget.notifyParent();
                    }),
                utils.DialogActionButton(
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
