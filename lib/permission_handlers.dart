import 'package:permission_handler/permission_handler.dart';

import 'package:aqua/utils/location.dart';
import 'package:aqua/utils/shared_pref_utils.dart';
import 'package:aqua/utils/widgets/global_navigator.dart';

String reminderMsg =
    "Reminders are key to AQUA's functioning. Do you wish to continue without reminders?";
String locationMsg =
    "Accessing your location allows us to calculate your water intake more accurately. Do you wish to continue without providing location access?";

Future<void> requestNotificationPermission() async {
  var status = await Permission.notification.request();
  if (status.isGranted) {
  } else if (status.isDenied) {
    GlobalNavigator.showAlertDialog(reminderMsg, null);
  }
}

Future<void> requestLocationPermission() async {
  var status = await Permission.location.request();
  if (status.isGranted) {
  } else if (status.isDenied) {

    // Ask user to manually enter location if location permissions denied
    final List<String> location = await GlobalNavigator.showAlertDialog(
        reminderMsg, const PickCityDialog());

    String address = "${location[0]}, ${location[1]}, ${location[2]}";
    await SharedPrefUtils.saveStr('place', address);
    final coordinates = await getCoordinates(address);
    await SharedPrefUtils.saveDouble('latitude', coordinates.latitude!);
    await SharedPrefUtils.saveDouble('longitude', coordinates.longitude!);
  }
}
