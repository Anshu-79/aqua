import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/screens/snapshot_screen.dart';

/// Defines a clickable button that opens up the [SnapshotScreen]
class ShareWidget extends StatelessWidget {
  const ShareWidget({super.key, required this.db, required this.prefs});
  final Database db;
  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: TextButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SnapshotScreen(prefs: prefs, db: db),
                )),
            child: const ButtonContent()));
  }
}

class ButtonContent extends StatelessWidget {
  const ButtonContent({super.key});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.pink.shade600;
    Color primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: AspectRatio(
        aspectRatio: 4.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: color.withOpacity(0.4),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color, width: 3)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.share_rounded, color: primaryColor),
              const SizedBox(width: 10),
              Expanded(
                child: FittedBox(
                  child: Text(
                    "Share stats",
                    style: TextStyle(
                        fontSize: 100,
                        fontWeight: FontWeight.w900,
                        color: primaryColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
