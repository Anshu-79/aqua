import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:drift/drift.dart' as drift;
import 'package:numberpicker/numberpicker.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils/colors.dart';
import 'package:aqua/utils/widgets/dialog_action_button.dart';

/// TextStyles used throughout the dialog
TextStyle dialogSubtext = const TextStyle(
    fontSize: 40, fontWeight: FontWeight.w900, color: Colors.black);

TextStyle textInput = const TextStyle(
    fontSize: 35, fontWeight: FontWeight.w900, color: Colors.black);

TextStyle textInputHint = const TextStyle(
    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey);

/// The placeholder data of the beverage to be displayed when a new beverage is to be added
Beverage defaultBeverage = Beverage(
    id: 1,
    name: '',
    colorCode: AquaColors.blue.toHexCode(),
    waterPercent: 50,
    starred: false);

/// This dialog provides a [TextFormField] & a [NumberPicker] for the user to add/edit a beverage
class BeverageDialog extends StatefulWidget {
  const BeverageDialog(
      {super.key, required this.beverage, required this.notifyParent});

  final Beverage? beverage;
  final VoidCallback notifyParent;

  @override
  State<BeverageDialog> createState() => _BeverageDialogState();
}

class _BeverageDialogState extends State<BeverageDialog> {
  final formKey = GlobalKey<FormState>();

  late int _waterPercent;
  late Color _currentColor;
  void changeColor(Color color) => setState(() => _currentColor = color);
  void changeWaterPercent(int percent) =>
      setState(() => _waterPercent = percent);

  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    final Beverage bev = widget.beverage ?? defaultBeverage;

    _waterPercent = bev.waterPercent;
    _currentColor = Color(int.parse('0x${bev.colorCode}'));
    nameController.text = bev.name;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: _currentColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
          side: BorderSide(width: 5, color: Theme.of(context).primaryColor)),
      child: SizedBox(
        height: 435,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NameInputField(formKey: formKey, controller: nameController),
                WaterPercentPicker(
                    changeWaterPercent: changeWaterPercent,
                    waterPercent: _waterPercent),
                ColorPicker(
                    currentColor: _currentColor, changeColor: changeColor),
                ActionButtons(
                    formKey: formKey,
                    controller: nameController,
                    bev: widget.beverage,
                    color: _currentColor,
                    waterPercent: _waterPercent,
                    notifyParent: widget.notifyParent)
              ]),
        ),
      ),
    );
  }
}

class NameInputField extends StatefulWidget {
  const NameInputField(
      {super.key, required this.controller, required this.formKey});

  final TextEditingController controller;
  final GlobalKey<FormState> formKey;

  @override
  State<NameInputField> createState() => _NameInputFieldState();
}

class _NameInputFieldState extends State<NameInputField> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: TextFormField(
          controller: widget.controller,
          textCapitalization: TextCapitalization.words,
          textAlign: TextAlign.center,
          style: textInput,
          cursorColor: Theme.of(context).primaryColor,
          decoration: InputDecoration(
            errorStyle: const TextStyle(color: Colors.white),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none),
            hintText: "Beverage Name",
            hintStyle: textInputHint,
            fillColor: Colors.white,
            filled: true,
          ),
          validator: (value) {
            if (value!.trim().isEmpty) return "Name cannot be empty";
            return null;
          },
        ),
      ),
    );
  }
}

class WaterPercentPicker extends StatefulWidget {
  const WaterPercentPicker(
      {super.key,
      required this.changeWaterPercent,
      required this.waterPercent});

  final int waterPercent;
  final Function changeWaterPercent;

  @override
  State<WaterPercentPicker> createState() => _WaterPercentPickerState();
}

class _WaterPercentPickerState extends State<WaterPercentPicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NumberPicker(
            itemCount: 1,
            itemHeight: 55,
            itemWidth: 90,
            selectedTextStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w900, fontSize: 50),
            textStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            minValue: 1,
            maxValue: 100,
            value: widget.waterPercent,
            onChanged: (newPercent) => widget.changeWaterPercent(newPercent)),
        Padding(
          padding: const EdgeInsets.only(top: 15, right: 10),
          child: Text("% water", style: dialogSubtext),
        )
      ],
    );
  }
}

class ColorPicker extends StatefulWidget {
  const ColorPicker(
      {super.key, required this.currentColor, required this.changeColor});
  final Color currentColor;
  final Function changeColor;

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  final double _borderRadius = 30;
  final double _iconSize = 15;

  Widget pickerLayoutBuilder(
      BuildContext context, List<Color> colors, PickerItem child) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [for (Color color in colors) child(color)],
      ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: BlockPicker(
          layoutBuilder: pickerLayoutBuilder,
          itemBuilder: pickerItemBuilder,
          availableColors: AquaColors.allColors,
          pickerColor: widget.currentColor,
          onColorChanged: (color) => widget.changeColor(color)),
    );
  }
}

class ActionButtons extends StatefulWidget {
  const ActionButtons(
      {super.key,
      required this.formKey,
      required this.controller,
      required this.bev,
      required this.color,
      required this.waterPercent,
      required this.notifyParent});

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final Beverage? bev;
  final Color color;
  final int waterPercent;
  final Function notifyParent;

  @override
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DialogActionButton(
            icon: const Icon(Icons.check),
            function: () {
              if (widget.formKey.currentState!.validate()) {
                final beverage = BeveragesCompanion(
                  id: (widget.bev != null)
                      ? drift.Value(widget.bev!.id)
                      : const drift.Value.absent(),
                  name: drift.Value(widget.controller.text.trim()),
                  colorCode: drift.Value(widget.color.toHexCode()),
                  waterPercent: drift.Value(widget.waterPercent),
                  starred: (widget.bev != null)
                      ? drift.Value(widget.bev!.starred)
                      : const drift.Value(false),
                );

                widget.notifyParent();
                Navigator.pop(context, ['edit', beverage]);
              }
            },
          ),
          (widget.bev != null)
              ? DialogActionButton(
                  icon: const Icon(Icons.delete_forever_outlined),
                  function: () {
                    Navigator.pop(context, ['delete', null]);
                    widget.notifyParent();
                  },
                )
              : const SizedBox.shrink(),
          DialogActionButton(
              icon: const Icon(Icons.close),
              function: () => Navigator.pop(context, ['exit', null]))
        ],
      ),
    );
  }
}
