import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/screens/onboarding/form/profile.dart';

Future<void> createUser(Profile profile, List<double?> location) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setString('name', profile.name!);
  prefs.setString('email', profile.email!);
  prefs.setString('sex', profile.sex!);
  prefs.setString('DOB', profile.dob!.toIso8601String());
  prefs.setInt('height', profile.height!);
  prefs.setInt('weight', profile.weight!);
  prefs.setInt('sleepTime', profile.sleepTime!);
  prefs.setInt('wakeTime', profile.wakeTime!);
  prefs.setInt('streak', 0);
  prefs.setDouble('latitude', location[0]!);
  prefs.setDouble('longitude', location[1]!);
  prefs.setDouble('altitude', location[2]!);
  prefs.setBool('onboard', true);
}

Future<void> savePictureLocally(File? image, String username) async {
  if (image == null) return;

  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$username.png';

  final newfile = await image.copy(filePath);

  SharedPrefUtils.saveStr('photo_path', newfile.path);
}

Future<File?> getProfilePicture() async {
  String? imgPath = await SharedPrefUtils.readPrefStr('photo_path');
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

  static Future<String?> readPrefStr(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }

  static Future<int?> readPrefInt(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt(key);
  }

  static Future<bool?> readPrefBool(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(key);
  }

  static Future<double?> readPrefDouble(String key) async {
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

  
}
