import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/screens/charts/chart_model.dart';
import 'package:aqua/screens/charts/total_intake_chart.dart';
import 'package:aqua/screens/user_profile/profile_picture.dart';
import 'package:aqua/screens/user_profile/statistics.dart';

class SnapshotScreen extends StatefulWidget {
  final GlobalKey _widgetKey = GlobalKey();

  SnapshotScreen({super.key, required this.prefs, required this.db});
  final SharedPreferences prefs;
  final Database db;

  @override
  State<SnapshotScreen> createState() => _SnapshotScreenState();
}

class _SnapshotScreenState extends State<SnapshotScreen> {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    Color canvasColor = Theme.of(context).canvasColor;
    Color splashColor = Theme.of(context).splashColor;
    LinearGradient bgGradient = LinearGradient(
        colors: [splashColor, canvasColor],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: const [0, 0.40]);

    return Scaffold(
      body: RepaintBoundary(
        key: widget._widgetKey,
        child: Container(
          decoration: BoxDecoration(gradient: bgGradient),
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor, width: 5)),
                  child: ProfilePicture(prefs: widget.prefs)),
              const SizedBox(height: 10),
              NameWidget(prefs: widget.prefs),
              const SizedBox(height: 10),
              StatsWidget(prefs: widget.prefs, db: widget.db),
              GenericChart(
                  headerText: "Hydration Chart",
                  dataFuture: widget.db.getWaterGoals(),
                  chartBuilder: (data) =>
                      TotalWaterTrendChart(waterGoals: data, daysRange: 7))
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 140,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(width: 3, color: primaryColor)),
          backgroundColor: Theme.of(context).splashColor,
          onPressed: () => _captureAndSave(context),
          child: const FABContent(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _captureAndSave(BuildContext context) async {
    try {
      RenderRepaintBoundary boundary = widget._widgetKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/image.png';
      final file = File(imagePath);
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles([XFile(imagePath)],
          text: 'Check out my hydration progress on Aqua!');

      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class FABContent extends StatelessWidget {
  const FABContent({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle style = const TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40);
    return Text("Share", style: style);
  }
}

class NameWidget extends StatelessWidget {
  const NameWidget({super.key, required this.prefs});
  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    final String name = prefs.getString('name')!;
    TextStyle style = TextStyle(
        fontSize: 100,
        fontWeight: FontWeight.w900,
        color: Theme.of(context).primaryColor);

    return FittedBox(fit: BoxFit.contain, child: Text(name, style: style));
  }
}
