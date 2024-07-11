import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:aqua/main.dart';

/// The [GlobalNavigator] class offers the functionality to 
/// show a [SnackBar], a [Dialog] & an [AlertDialog] 
/// without passing a [BuildContext] instance.
class GlobalNavigator {
  static void showSnackBar(String text, Color? color) {
    BuildContext context = navigatorKey.currentContext!;
    Color canvasColor = Theme.of(context).canvasColor;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 1000),
        content: Text(text, style: TextStyle(color: canvasColor)),
        backgroundColor: color,
        action: SnackBarAction(
            label: 'Dismiss', textColor: canvasColor, onPressed: () {})));
  }

  static Future<dynamic>? showAlertDialog(
      String text, Widget? backupData) async {
    return await showDialog(
        barrierDismissible: false,
        context: navigatorKey.currentContext!,
        builder: (context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              title: const Text("Permission denied"),
              content: Text(text),
              actions: [
                TextButton(
                    onPressed: () async => await openAppSettings(),
                    child: const Text("Open Settings")),
                TextButton(
                    onPressed: () async {
                      if (backupData != null) {
                        final val = await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return PopScope(canPop: false, child: backupData);
                            });
                        if (context.mounted) Navigator.pop(context, val);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Continue")),
              ]
            ),
          );
        });
  }

  // Displays the dialog with a subtle down-to-up animation
  static Future<dynamic>? showAnimatedDialog(Widget dialog) async {
    return await showGeneralDialog(
      context: navigatorKey.currentContext!,
      transitionDuration: const Duration(milliseconds: 500),
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) => const Placeholder(),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * -200, 0.0),
          child: Opacity(opacity: a1.value, child: dialog),
        );
      },
    );
  }
}
