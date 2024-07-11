import 'package:flutter/material.dart';

/// An implementation of [GestureDetector] that displays a question mark
/// It is always aligned to the right side of the screen
/// It is advised to use it in a [Stack] on top of other widgets to prevent changes to widget position
/// It displays a tooltip when clicked on
/// The need for this widget stems from the fact that tooltips need to be 
/// long pressed to be shown
class TooltipOnTap extends StatefulWidget {
  const TooltipOnTap({super.key, required this.message});

  final String message;

  @override
  State<TooltipOnTap> createState() => _TooltipOnTapState();
}

class _TooltipOnTapState extends State<TooltipOnTap> {
  final GlobalKey _toolTipKey = GlobalKey();

  void _showTooltip() {
    final dynamic tooltip = _toolTipKey.currentState;
    tooltip.ensureTooltipVisible();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 40, right: 10),
        child: GestureDetector(
            onTap: _showTooltip,
            child: Tooltip(
              key: _toolTipKey,
              message: widget.message,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                child: Icon(Icons.question_mark_rounded,
                    size: 30, color: Theme.of(context).canvasColor),
              ),
            )),
      ),
    );
  }
}
