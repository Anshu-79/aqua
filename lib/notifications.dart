import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:aqua/utils.dart' as utils;

initLocalNotifications() {
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: 'hydration_notifications',
            channelName: 'Hydration notifications',
            channelDescription: 'Notification channel for Hydration reminders',
            defaultColor: utils.defaultColors['dark blue'],
            defaultPrivacy: NotificationPrivacy.Public,
            channelShowBadge: true,
            importance: NotificationImportance.Default,
            enableVibration: true,
            vibrationPattern: lowVibrationPattern,
            criticalAlerts: true),
      ],
      debug: true);
}

Future<void> createHydrationNotification(int minutes) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: -1,
      channelKey: 'hydration_notifications',
      title: '${Emojis.wheater_droplet} Add some water!',
      body: 'Drink water regularly to stay healthy.',
      notificationLayout: NotificationLayout.BigPicture,
      largeIcon: "asset://assets/images/icon.png",
    ),
    schedule: NotificationInterval(interval: 60 * minutes),
  );
}
