import 'package:aqua/location_utils.dart';
import 'package:aqua/shared_pref_utils.dart';
import 'package:aqua/utils.dart' as utils;
import 'package:permission_handler/permission_handler.dart';

String reminderMsg =
    "Reminders are key to AQUA's functioning. Do you wish to continue without reminders?";
String locationMsg =
    "Accessing your location allows us to calculate your water intake more accurately. Do you wish to continue without providing location access?";

Future<void> requestNotificationPermission() async {
  var status = await Permission.notification.request();
  if (status.isGranted) {
    print("Notification permission granted");
  } else if (status.isDenied) {
    // Permission is denied
    print('Notification permission denied.');
    utils.GlobalNavigator.showAlertDialog(reminderMsg, null);
  }
}

Future<void> requestLocationPermission() async {
  var status = await Permission.location.request();
  if (status.isGranted) {
    print("Location permission granted");
  } else if (status.isDenied) {
    // Permission is denied
    print('Location permission denied.');

    final List<String> location = await utils.GlobalNavigator.showAlertDialog(
        reminderMsg, const PickCityDialog());

    String address = "${location[0]}, ${location[1]}, ${location[2]}";
    final coordinates = await getCoordinates(address);
    await SharedPrefUtils.saveDouble('latitude', coordinates.latitude!);
    await SharedPrefUtils.saveDouble('longitude', coordinates.longitude!);
  }
}
