import 'package:flutter/material.dart';

import 'package:aqua/dialog_boxes/beverage.dart';
import 'package:aqua/database/database.dart';

class EditBeverageDialog extends StatefulWidget {
  const EditBeverageDialog(
      {super.key, required this.beverage, required this.notifyParent});

  final Beverage beverage;
  final VoidCallback notifyParent;

  @override
  State<EditBeverageDialog> createState() => _EditBeverageDialogState();
}

class _EditBeverageDialogState extends State<EditBeverageDialog> {
  @override
  Widget build(BuildContext context) {
    return BeverageDialog(
      beverage: widget.beverage,
      notifyParent: widget.notifyParent,
    );
  }
}
