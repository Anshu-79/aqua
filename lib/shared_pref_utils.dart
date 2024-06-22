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
  prefs.setDouble('altitude', location[2] ?? 0);
  prefs.setBool('onboard', true);

  Set<String> keys = prefs.getKeys();
  print(keys);
}

class SharedPrefUtils {
  static void saveStr(String key, String message) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(key, message);
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
      String city, String state, String country) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('city', city);
    pref.setString('state', state);
    pref.setString('country', country);
  }

  static Future<String> getLocation() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? city = pref.getString('city');
    String? state = pref.getString('state');
    String? country = pref.getString('country');

    return "$city, $state, $country";
  }
}
