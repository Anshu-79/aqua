import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/utils/height_picker.dart';
import 'package:aqua/utils.dart' as utils;

class HeightEditDialog extends StatefulWidget {
  const HeightEditDialog(
      {super.key, required this.notifyParent, required this.prefs});

  final VoidCallback notifyParent;
  final SharedPreferences prefs;

  @override
  State<HeightEditDialog> createState() => _HeightEditDialogState();
}

class _HeightEditDialogState extends State<HeightEditDialog> {
  late int height;
  refresh(h) => setState(() => height = h);

  @override
  void initState() {
    height = widget.prefs.getInt('height') ?? 150;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    Color canvasColor = Theme.of(context).canvasColor;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
          side: BorderSide(color: primaryColor, width: 3)),
      backgroundColor: canvasColor,
      child: Container(
        height: 500,
        padding: const EdgeInsets.all(5),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeightPicker(height: height, notifyParent: refresh),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                utils.DialogActionButton(
                    icon: const Icon(Icons.check),
                    function: () async {
                      widget.prefs.setInt('height', height);
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
