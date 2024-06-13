import 'package:aqua/utils.dart' as utils;
import 'package:permission_handler/permission_handler.dart';

Future<void> requestNotificationPermission() async {
  var status = await Permission.notification.request();
  if (status.isGranted) {
    print("Notification permission granted");
  } else if (status.isDenied) {
    // Permission is denied
    print('Notification permission denied.');
    utils.GlobalNavigator.showAlertDialog(
        "Reminders are key to AQUA's functioning. Do you wish to continue without reminders?");
  }
}
