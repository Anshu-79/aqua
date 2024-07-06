import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/utils.dart' as utils;

class NameEditDialog extends StatefulWidget {
  const NameEditDialog(
      {super.key,
      required this.name,
      required this.notifyParent,
      required this.prefs});

  final String name;
  final VoidCallback notifyParent;
  final SharedPreferences prefs;

  @override
  State<NameEditDialog> createState() => _NameEditDialogState();
}

class _NameEditDialogState extends State<NameEditDialog> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    TextEditingController nameController =
        TextEditingController(text: widget.name);

    Color primaryColor = Theme.of(context).primaryColor;
    Color canvasColor = Theme.of(context).canvasColor;

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
          side: BorderSide(color: primaryColor, width: 3)),
      backgroundColor: canvasColor,
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 225,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Form(
              key: formKey,
              child: TextFormField(
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                textAlign: TextAlign.center,
                cursorColor: Theme.of(context).splashColor,
                style:
                    TextStyle(color: canvasColor, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: primaryColor),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none),
                  hintText: "Your Name",
                  hintStyle: utils.ThemeText.textInputHint,
                  fillColor: primaryColor,
                  filled: true,
                ),
                validator: (value) {
                  if (value!.trim().isEmpty) return "Name cannot be empty";
                  return null;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                utils.DialogActionButton(
                  icon: const Icon(Icons.check),
                  function: () async {
                    if (formKey.currentState!.validate()) {
                      final name = nameController.text;
                      widget.prefs.setString('name', name);
                      Navigator.pop(context);
                      widget.notifyParent();
                    }
                  },
                ),
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
