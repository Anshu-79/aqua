import 'package:weather/weather.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:location/location.dart';

import 'package:aqua/utils/shared_pref_utils.dart';
import 'package:aqua/utils/location.dart';

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

// Call OpenWeatherAPI to get today's weather
Future<Weather?> getWeather() async {
  if (await SharedPrefUtils.readBool('onboard') == null) return null;

  String? apiKey = await readAPIKey('weather');

  WeatherFactory wf = WeatherFactory(apiKey!);

  double defaultLat = defaultCoordinates[0];
  double defaultLong = defaultCoordinates[1];

  // First try to get current location's weather
  final location = Location();

  if (await location.serviceEnabled()) {
    final currentLocation = await location.getLocation();
    double lat = currentLocation.latitude!;
    double long = currentLocation.longitude!;

    // If current location is available, change prefs according to it
    SharedPrefUtils.setLocation(lat, long);
    return await wf.currentWeatherByLocation(lat, long);
  }

  // If current location not available, use stored location
  final savedLocation = await SharedPrefUtils.getLocation();
  final lat = savedLocation[0] ?? defaultLat;
  final long = savedLocation[1] ?? defaultLong;
  return await wf.currentWeatherByLocation(lat, long);
}

Future<void> saveWeather() async {
  Weather? w = await getWeather();

  String place = "Mumbai, IN";
  double temperature = 20;

  if (w != null) {
    place = "${w.areaName!}, ${w.country!}";
    temperature = w.temperature!.celsius!;
  }

  await SharedPrefUtils.saveStr('place', place);
  await SharedPrefUtils.saveDouble('temperature', temperature);
}
