import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyTaskManager {
  static Future<void> checkAndRunTask(Function runDailyTask) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastRun = prefs.getString("last_run");
    String today = DateUtils.dateOnly(DateTime.now()).toIso8601String();

    // Check if day has changed
    if (lastRun == null || lastRun != today) {
      await runDailyTask();
      await prefs.setString('last_run', today);
    }
  }
}
