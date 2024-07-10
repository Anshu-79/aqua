import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils/shared_pref_utils.dart';
import 'package:aqua/permission_handlers.dart';
import 'package:aqua/utils/colors.dart';

List<String> notificationTitles = [
  "${Emojis.animals_swan} Don't Hate! Hydrate!",
  "${Emojis.wheater_droplet} Stay Refreshed: Drink Water Now!",
  "${Emojis.wheater_water_wave} Hydrate for Health: Time for Water!",
  "${Emojis.icon_sweat_droplets} Water Reminder: Keep Hydrated!",
  "${Emojis.food_cup_with_straw} It's Water O'Clock: Take a Sip!",
  "${Emojis.time_alarm_clock} Water Break: Refresh Yourself!",
  "${Emojis.person_activity_person_walking} Pause and Hydrate: Drink Up!",
  "${Emojis.plant_herb} Hydrate Alert: Drink Some Water!",
  "${Emojis.emotion_blue_heart} Drink Reminder: Stay Hydrated!",
  "${Emojis.wheater_droplet} Water Time: Keep Hydrating!"
];

String getNotificationBody(int volume) {
  List<String> notificationBodies = [
    "Time for another $volume mL to stay on track!",
    "Drink $volume mL more to move towards your goal!",
    "You're almost there! Have $volume mL more!",
    "Keep it up! Drink another $volume mL!",
    "Stay on track with another $volume mL!",
    "Don't forget to drink $volume mL more!",
    "Another $volume mL to keep hydrated!",
    "Stay refreshed! Drink $volume mL more!",
    "Top off your hydration with $volume mL more!",
    "Don't stop now! $volume mL more!",
  ];
  int randomIdx = Random().nextInt(notificationBodies.length);
  return notificationBodies[randomIdx];
}

class NotificationsController {
  static ReceivedAction? action;

  static Future<void> initLocalNotifications() async {
    AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              channelKey: 'hydration_notifications',
              channelName: 'Hydration notifications',
              channelDescription:
                  'Notification channel for Hydration reminders',
              defaultColor: AquaColors.darkBlue,
              defaultPrivacy: NotificationPrivacy.Public,
              channelShowBadge: true,
              importance: NotificationImportance.Default,
              enableVibration: true,
              vibrationPattern: lowVibrationPattern,
              criticalAlerts: true),
        ],
        debug: true);
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) requestNotificationPermission();
    });
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationsController.onActionReceivedMethod);
  }

  static Future<void> createHydrationNotification(
      int minutes, int volume) async {
    int randomIdx = Random().nextInt(notificationTitles.length);
    String imgURL = "asset://assets/images/icon.png";

    // Change the img to the meme hydration_duck if text is from the meme
    if (randomIdx == 0) imgURL = "asset://assets/images/hydration_duck.png";

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: 'hydration_notifications',
        title: notificationTitles[randomIdx],
        body: getNotificationBody(volume),
        notificationLayout: NotificationLayout.BigPicture,
        largeIcon: imgURL,
        payload: {"volume": volume.toString()},
      ),
      actionButtons: [
        NotificationActionButton(
            key: 'ADD',
            label: 'Add $volume mL',
            actionType: ActionType.SilentBackgroundAction),
        NotificationActionButton(
            key: 'TURN OFF',
            label: 'Turn off reminders',
            actionType: ActionType.SilentAction)
      ],
      schedule: NotificationInterval(interval: 60 * minutes, repeats: true),
    );
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction action) async {
    if (action.buttonKeyPressed == 'ADD') {
      String vol = action.payload!['volume']!;
      Fluttertoast.showToast(msg: "$vol mL water added");
      int volume = int.parse(action.payload!['volume']!);

      Database db = Database();
      await db.insertWater(volume);
      await db.updateConsumedVolume(volume);
      db.close();
    } else if (action.buttonKeyPressed == 'TURN OFF') {
      await SharedPrefUtils.saveBool('reminders', false);
      Fluttertoast.showToast(msg: "Reminders turned off");
    }
  }

  static Future<void> cancelScheduledNotifications() async =>
      await AwesomeNotifications().cancelAllSchedules();

  static Future<void> updateScheduledNotifications(
      int minutes, int volume) async {
    await cancelScheduledNotifications();
    await createHydrationNotification(minutes, volume);
  }

  static Future<void> killNotificationsDuringSleepTime() async {
    int wakeHr = await SharedPrefUtils.getWakeTime();
    int sleepHr = await SharedPrefUtils.getSleepTime();

    DateTime now = DateTime.now();
    int nowHr = now.hour;

    bool beforeSleeping = nowHr < min(wakeHr, sleepHr);
    bool afterSleeping = nowHr > max(wakeHr, sleepHr);

    if (!beforeSleeping && !afterSleeping) {

      // Set the next reminder to the wakeTime of next day if 
      // sleep time has started
      DateTime wakeTime = DateTime(now.year, now.month, now.day, wakeHr);
      if (wakeTime.isBefore(now)) {
        wakeTime = wakeTime.add(const Duration(days: 1));
      }

      int minsToWake = wakeTime.difference(now).inMinutes;
      await updateScheduledNotifications(minsToWake, 200);
    }
  }
}
