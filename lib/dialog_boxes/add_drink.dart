import 'package:aqua/shared_pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:numberpicker/numberpicker.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils/colors.dart';
import 'package:aqua/utils/widgets/dialog_action_button.dart';

class AddDrinkDialog extends StatefulWidget {
  const AddDrinkDialog(
      {super.key, required this.beverages, required this.notifyParent});

  final List<Beverage> beverages;
  final Function notifyParent;

  @override
  State<AddDrinkDialog> createState() => _AddDrinkDialogState();
}

class _AddDrinkDialogState extends State<AddDrinkDialog> {
  int _bevIndex = 0;
  int _volume = 200;

  void changeDrink(int jump) {
    final int len = widget.beverages.length;

    // Allows to move through beverages circularly
    if (jump == -1) {
      if (_bevIndex == 0) return setState(() => _bevIndex = len - 1);
    } else {
      if (_bevIndex == len - 1) return setState(() => _bevIndex = 0);
    }

    return setState(() => _bevIndex += jump);
  }

  void changeVolume(int volume) => setState(() => _volume = volume);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.only(top: 150),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
            side: BorderSide(width: 5, color: Theme.of(context).primaryColor)),
        backgroundColor: widget.beverages[_bevIndex].colorCode.toColor(),
        child: Container(
          alignment: Alignment.bottomCenter,
          height: 400,
          width: 150,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LeftButton(bevIndex: _bevIndex, changeDrink: changeDrink),
                    BeverageName(bevName: widget.beverages[_bevIndex].name),
                    RightButton(bevIndex: _bevIndex, changeDrink: changeDrink)
                  ],
                ),
                VolumePicker(volume: _volume, changeVolume: changeVolume),
                ActionButtons(
                    id: widget.beverages[_bevIndex].id, volume: _volume)
              ],
            ),
          ),
        ));
  }
}

class LeftButton extends StatelessWidget {
  const LeftButton(
      {super.key, required this.bevIndex, required this.changeDrink});
  final int bevIndex;
  final Function changeDrink;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.chevron_left),
        color: Colors.black,
        style: IconButton.styleFrom(backgroundColor: Colors.white),
        onPressed: () => changeDrink(-1));
  }
}

class RightButton extends StatelessWidget {
  const RightButton(
      {super.key, required this.bevIndex, required this.changeDrink});
  final int bevIndex;
  final Function changeDrink;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.chevron_right),
      color: Colors.black,
      style: IconButton.styleFrom(backgroundColor: Colors.white),
      onPressed: () => changeDrink(1),
    );
  }
}

class BeverageName extends StatelessWidget {
  const BeverageName({super.key, required this.bevName});
  final String bevName;

  @override
  Widget build(BuildContext context) {
    TextStyle bevNameStyle = const TextStyle(
        fontSize: 45, fontWeight: FontWeight.w900, color: Colors.black);

    return SizedBox(
      width: 150,
      height: 80,
      child: FittedBox(
        fit: BoxFit.contain,
        clipBehavior: Clip.antiAlias,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          child: Text(bevName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: bevNameStyle),
        ),
      ),
    );
  }
}

class VolumePicker extends StatefulWidget {
  const VolumePicker(
      {super.key, required this.volume, required this.changeVolume});
  final int volume;
  final Function changeVolume;
  @override
  State<VolumePicker> createState() => _VolumePickerState();
}

class _VolumePickerState extends State<VolumePicker> {
  TextStyle subtextStyle = const TextStyle(
      fontSize: 45, fontWeight: FontWeight.w900, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NumberPicker(
            itemHeight: 60,
            itemWidth: 120,
            selectedTextStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w900, fontSize: 50),
            textStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            axis: Axis.vertical,
            minValue: 25,
            step: 25,
            maxValue: 1000,
            value: widget.volume,
            onChanged: (value) => widget.changeVolume(value)),
        const SizedBox(width: 10),
        Text("mL", style: subtextStyle)
      ],
    );
  }
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key, required this.id, required this.volume});
  final int id;
  final int volume;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DialogActionButton(
          icon: const Icon(Icons.check),
          function: () async {
            final drink = DrinksCompanion(
                bevID: drift.Value(id),
                volume: drift.Value(volume),
                datetime: drift.Value(DateTime.now()),
                datetimeOffset:
                    drift.Value(await SharedPrefUtils.getWakeTime()));

            if (context.mounted) Navigator.pop(context, drink);
          },
        ),
        DialogActionButton(
            icon: const Icon(Icons.close),
            function: () => Navigator.of(context, rootNavigator: true).pop())
      ],
    );
  }
}
