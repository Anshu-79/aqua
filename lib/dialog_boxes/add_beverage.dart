import 'package:flutter/material.dart';

import 'package:aqua/dialog_boxes/beverage.dart';

class AddBeverageDialog extends StatefulWidget {
  const AddBeverageDialog({super.key, required this.notifyParent});
  final VoidCallback notifyParent;

  @override
  State<AddBeverageDialog> createState() => _AddBeverageDialogState();
}

class _AddBeverageDialogState extends State<AddBeverageDialog> {
  @override
  Widget build(BuildContext context) =>
      BeverageDialog(beverage: null, notifyParent: widget.notifyParent);
}
