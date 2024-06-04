import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:drift/drift.dart' as drift;

import 'package:aqua/database/database.dart';
import 'package:aqua/utils.dart' as utils;

class EditBeverageDialog extends StatefulWidget {
  const EditBeverageDialog(
      {super.key, required this.notifyParent, required this.beverage});

  final Function() notifyParent;
  final Beverage beverage;

  @override
  State<EditBeverageDialog> createState() => _EditBeverageDialogState();
}

class _EditBeverageDialogState extends State<EditBeverageDialog> {
  final formKey = GlobalKey<FormState>();

  late int _waterPercent;
  late Color _currentColor;
  void changeColor(Color color) => setState(() {
        _currentColor = color;
      });

  TextEditingController beverageNameController = TextEditingController();

  //final int _portraitCrossAxisCount = 6;
  final double _borderRadius = 30;
  final double _iconSize = 15;

  @override
  void initState() {
    _waterPercent = widget.beverage.waterPercent;
    _currentColor = Color(int.parse('0x${widget.beverage.colorCode}'));
    beverageNameController.text = widget.beverage.bevName;
    super.initState();
  }

  @override
  void dispose() {
    beverageNameController.dispose();
    super.dispose();
  }

  Widget pickerLayoutBuilder(
      BuildContext context, List<Color> colors, PickerItem child) {
    return Row(
      //crossAxisCount: _portraitCrossAxisCount,
      //crossAxisSpacing: 2,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [for (Color color in colors) child(color)],
    );
  }

  Widget pickerItemBuilder(
      Color color, bool isCurrentcolor, void Function() changeColor) {
    return Container(
      height: 35,
      width: 35,
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(_borderRadius),
        color: color,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: changeColor,
          splashColor: Colors.white,
          borderRadius: BorderRadius.circular(_borderRadius),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: isCurrentcolor ? 1 : 0,
            child: Icon(
              Icons.check,
              size: _iconSize,
              color: useWhiteForeground(color) ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      //insetPadding: const EdgeInsets.only(top: 100),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
        side: BorderSide(width: 5, color: Theme.of(context).primaryColor),
      ),
      backgroundColor: _currentColor,
      surfaceTintColor: Colors.transparent,
      child: Form(
        key: formKey,
        child: SizedBox(
          height: 435,
          //width: MediaQuery.of(context).size.width - 60,
          //alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40),
                    child: TextFormField(
                      cursorColor: Theme.of(context).primaryColor,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "Name cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      controller: beverageNameController,
                      textCapitalization: TextCapitalization.words,
                      textAlign: TextAlign.center,
                      style: utils.ThemeText.textInput,
                      decoration: InputDecoration(
                        errorStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none),
                        hintText: "Beverage Name",
                        hintStyle: utils.ThemeText.textInputHint,
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NumberPicker(
                          itemHeight: 55,
                          itemWidth: 90,
                          selectedTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 50),
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          minValue: 1,
                          maxValue: 100,
                          value: _waterPercent,
                          onChanged: (value) =>
                              setState(() => _waterPercent = value)),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, right: 10),
                        child: Text(
                          "% water",
                          style: utils.ThemeText.dialogSubtext,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10),
                    child: BlockPicker(
                        layoutBuilder: pickerLayoutBuilder,
                        itemBuilder: pickerItemBuilder,
                        availableColors: utils.colorList,
                        pickerColor: _currentColor,
                        onColorChanged: changeColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        utils.addDrinkDialogButtons(
                          icon: const Icon(Icons.check),
                          function: () {
                            if (formKey.currentState!.validate()) {
                              final beverage = BeveragesCompanion(
                                bevID: drift.Value(widget.beverage.bevID),
                                bevName: drift.Value(beverageNameController.text),
                                colorCode:
                                    drift.Value(utils.toHexString(_currentColor)),
                                waterPercent: drift.Value(_waterPercent),
                              );
                                
                              print("BevID: ${widget.beverage.bevID} edited");
                              widget.notifyParent();
                              Navigator.pop(context, [0, beverage]);
                            }
                          },
                        ),
                        utils.addDrinkDialogButtons(
                          function: () {
                            Navigator.pop(context, [1, widget.beverage.bevID]);
                            widget.notifyParent();
                          },
                          icon: const Icon(Icons.delete_forever_outlined),
                        ),
                        utils.addDrinkDialogButtons(
                            icon: const Icon(Icons.close),
                            function: () => Navigator.pop(context, [2, null]))
                      ],
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
