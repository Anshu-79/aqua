import 'package:flutter/material.dart';

import 'package:aqua/utils.dart' as utils;

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const utils.UniversalHeader(title: "Settings"),
      body: Container(),
    );
  }
}
