import 'package:aqua/shared_pref_utils.dart';
import 'package:weather/weather.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:aqua/api_keys.dart';

// Safe API Key Storage Helper Functions
getAndroidOptions() => const AndroidOptions(encryptedSharedPreferences: true);
getIOSOptions() =>
    const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

final storage = FlutterSecureStorage(
    aOptions: getAndroidOptions(), iOptions: getIOSOptions());

void writeAPIKey(String serviceName, String key) async {
  await storage.write(
    key: serviceName,
    value: key,
    aOptions: getAndroidOptions(),
    iOptions: getIOSOptions(),
  );
}

Future<String?> readAPIKey(String serviceName) async {
  return await storage.read(
    key: serviceName,
    aOptions: getAndroidOptions(),
    iOptions: getIOSOptions(),
  );
}

Future<String?> initAPIKeys(SharedPreferences prefs) async {
  if (prefs.getBool('onboard') == true) return await readAPIKey('weather');

  writeAPIKey('weather', openWeatherKey);
  return await readAPIKey('weather');
}

// Calls OpenWeatherAPI to get today's weather
Future<void> getWeather(String apiKey, SharedPreferences prefs) async {
  WeatherFactory wf = WeatherFactory(apiKey);

  // Get weather using geo coordinates if available
  double? lat = await SharedPrefUtils.readPrefDouble('latitude');
  double? long = await SharedPrefUtils.readPrefDouble('longitude');

  // if (lat != null && long != null) {
    print(await wf.currentWeatherByLocation(lat!, long!));
    // return await wf.currentWeatherByLocation(lat, long);
  // } else {
    String? city = await SharedPrefUtils.readPrefStr('city');
    print(await wf.currentWeatherByCityName(city!));
    // return await wf.currentWeatherByCityName(city!);
  // }
}
