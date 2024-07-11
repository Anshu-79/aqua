import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:geocode/geocode.dart';

import 'package:aqua/utils/colors.dart';
import 'package:aqua/utils/shared_pref_utils.dart';

/// Fetches the user's current location
Future<List<double?>> getCurrentLocation() async {
  Location location = Location();

  final storedLat = await SharedPrefUtils.readDouble('latitude');
  final storedLong = await SharedPrefUtils.readDouble('longitude');

  bool serviceEnabled = await location.serviceEnabled();
  PermissionStatus permission = await location.hasPermission();

  if (!serviceEnabled) serviceEnabled = await location.requestService();

  if (permission != PermissionStatus.granted) {
    // If permission wasn't granted, return existing lat & long
    if (storedLat != null) return [storedLat, storedLong, 0];

    return [28.70405920, 77.10249020, 216]; // Coordinates of Delhi
  }

  // If permission was granted, fetch location and return it
  LocationData locationData = await location.getLocation();
  return [locationData.latitude, locationData.longitude, locationData.altitude];
}

/// A geocoder that geocodes the address obtained from [PickCityDialog]
Future<Coordinates> getCoordinates(String address) async {
  GeoCode geoCode = GeoCode();
  try {
    Coordinates coordinates = await geoCode.forwardGeocoding(address: address);
    return coordinates;
  } catch (e) {
    return Future.error(e);
  }
}

/// This dialog is displayed when the user refuses to give location permission
class PickCityDialog extends StatefulWidget {
  const PickCityDialog({super.key});

  @override
  State<PickCityDialog> createState() => _PickCityDialogState();
}

class _PickCityDialogState extends State<PickCityDialog> {
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "Select your location manually",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            CountryStateCityPicker(
                dialogColor: Theme.of(context).canvasColor,
                country: country,
                state: state,
                city: city,
                textFieldDecoration: InputDecoration(
                    suffixIcon: const Icon(Icons.arrow_downward_rounded),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor)))),
            TextButton(
              onPressed: () {
                if (city.text != "" && state.text != "") {
                  List<String> address = [city.text, state.text, country.text];
                  Navigator.pop(context, address);
                }
              },
              style: TextButton.styleFrom(backgroundColor: AquaColors.darkBlue),
              child: const Text(
                "Continue",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
