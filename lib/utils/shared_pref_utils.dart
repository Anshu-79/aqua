import 'dart:io';
import 'dart:ui';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/screens/onboarding/form/profile.dart';

Future<void> createUser(Profile profile, List<double?> location) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final bool isDarkMode = PlatformDispatcher.instance.platformBrightness == Brightness.dark;
  final DateTime dob = profile.dob ?? DateTime(2000, 1, 1);

  prefs.setString('name', profile.name ?? "User Name");
  prefs.setString('email', profile.email ?? "email@email.com");
  prefs.setString('sex', profile.sex ?? 'M');
  prefs.setString('DOB', dob.toIso8601String());
  prefs.setInt('height', profile.height ?? 150);
  prefs.setInt('weight', profile.weight ?? 60);
  prefs.setInt('sleepTime', profile.sleepTime ?? 0);
  prefs.setInt('wakeTime', profile.wakeTime ?? 8);
  prefs.setInt('streak', 0);
  prefs.setDouble('latitude', location[0]!);
  prefs.setDouble('longitude', location[1]!);
  prefs.setDouble('altitude', location[2]!);
  prefs.setBool('onboard', true);
  prefs.setBool('darkMode', isDarkMode);
  prefs.setBool('reminders', true);
}

Future<void> savePictureLocally(File? image, String username) async {
  if (image == null) return;

  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$username.png';

  final newfile = await image.copy(filePath);

  SharedPrefUtils.saveStr('photo_path', newfile.path);
}

Future<File?> getProfilePicture() async {
  String? imgPath = await SharedPrefUtils.readStr('photo_path');
  return (imgPath == null) ? null : File(imgPath);
}

class SharedPrefUtils {
  static Future<void> saveStr(String key, String message) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(key, message);
  }

  static Future<void> saveDouble(String key, double message) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setDouble(key, message);
  }

  static Future<void> saveBool(String key, bool b) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(key, b);
  }

  static Future<String?> readStr(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }

  static Future<int?> readInt(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt(key);
  }

  static Future<bool?> readBool(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(key);
  }

  static Future<double?> readDouble(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getDouble(key);
  }

  static Future<void> setLocation(
      double latitude, double longitude) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setDouble('city', latitude);
    pref.setDouble('state', longitude);
  }

  static Future<List<double?>> getLocation() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    double? lat = pref.getDouble('city');
    double? long = pref.getDouble('state');
    return [lat, long];
  }

  static Future<int> getWakeTime() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    int? wakeTime = pref.getInt('wakeTime');
    return wakeTime ?? 8;
  }

  static Future<int> getSleepTime() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    int? sleepTime = pref.getInt('sleepTime');
    return sleepTime ?? 0;
  }
  
}
