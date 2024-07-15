import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/screens/user_profile/dialogs/name_edit_dialog.dart';
import 'package:aqua/utils/textstyles.dart';
import 'package:aqua/utils/widgets/global_navigator.dart';

/// This widget is a simple [TextButton] that displays the username
class NameWidget extends StatefulWidget {
  const NameWidget({super.key, required this.prefs});
  final SharedPreferences prefs;

  @override
  State<NameWidget> createState() => _NameWidgetState();
}

class _NameWidgetState extends State<NameWidget> {
  refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final String name = widget.prefs.getString('name')!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: TextButton(
        style: TextButton.styleFrom(
            elevation: 5,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shadowColor: Colors.black,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: Center(
          child: AutoSizeText(name,
              style: ProfileScreenStyles.username,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              maxFontSize: 40),
        ),
        onPressed: () => GlobalNavigator.showAnimatedDialog(NameEditDialog(
            name: name, notifyParent: refresh, prefs: widget.prefs)),
      ),
    );
  }
}
