import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/utils/weight_picker.dart';
import 'package:aqua/utils.dart' as utils;

class WeightEditDialog extends StatefulWidget {
  const WeightEditDialog(
      {super.key, required this.notifyParent, required this.prefs});

  final VoidCallback notifyParent;
  final SharedPreferences prefs;

  @override
  State<WeightEditDialog> createState() => _WeightEditDialogState();
}

class _WeightEditDialogState extends State<WeightEditDialog> {
  late int weight;
  refresh(w) => setState(() => weight = w);

  @override
  void initState() {
    weight = widget.prefs.getInt('weight') ?? 60;
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
        height: 470,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center_rounded,
                size: 60, color: utils.defaultColors['dark blue']),
                const SizedBox(height: 20),
            WeightPicker(weight: weight, textSize: 50, notifyParent: refresh),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                utils.DialogActionButton(
                    icon: const Icon(Icons.check),
                    function: () async {
                      widget.prefs.setInt('weight', weight);
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
