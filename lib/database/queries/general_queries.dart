import 'package:aqua/database/database.dart';
import 'package:aqua/utils/shared_pref_utils.dart';

/// Extension on the `Database` class to provide some miscellaneous queries.
extension GeneralQueries on Database {
  /// Calculates the median of the last [sampleSize] drinks
  Future<int> calcMedianDrinkSize() async {
    int sampleSize = 20; // Number of recent drinks to calculate median

    List<Drink>? drinks = await getLastNDrinks(sampleSize);

    if (drinks == null) return 200;

    List<int> drinkSizes =
        List.generate(drinks.length, (i) => drinks[i].volume);
    drinkSizes.sort();

    return drinkSizes[drinkSizes.length ~/ 2]; // Median is at middle position
  }

  /// Calculates the duration between each subsequent reminder from now
  ///
  /// The input variables [consumed] & [total] are nullable since they
  /// don't need to be passed everytime. Currently, they are passed only when
  /// the function is called from [setTodaysGoal]
  Future<int> calcReminderGap(int? consumed, int? total) async {
    DateTime now = DateTime.now();

    WaterGoal? todaysGoal = await getGoal(now);

    consumed ??= todaysGoal!.consumedVolume;
    total ??= todaysGoal!.totalVolume;

    final int toDrink = total - consumed;

    // If day's goal has been completed, next reminder will
    // be at the waking time of next day
    if (toDrink <= 0) {
      final wakeHour = await SharedPrefUtils.getWakeTime();
      DateTime wakeTime = DateTime(now.year, now.month, now.day, wakeHour);

      if (wakeTime.isBefore(now)) {
        wakeTime = wakeTime.add(const Duration(days: 1));
      }
      return wakeTime.difference(now).inMinutes;
    }

    final int drinkSize = await calcMedianDrinkSize();
    int drinksNeeded = toDrink ~/ drinkSize;

    // Assumes a minimum of 1 drink
    if (drinksNeeded == 0) drinksNeeded = 1;

    final int sleepHour = await SharedPrefUtils.getSleepTime();
    DateTime sleepTime = DateTime(now.year, now.month, now.day, sleepHour);

    if (sleepTime.isBefore(now)) {
      sleepTime = sleepTime.add(const Duration(days: 1));
    }

    Duration timeLeft = sleepTime.difference(now);

    double reminderGap = timeLeft.inMinutes / drinksNeeded;

    if (reminderGap < 10) return 10; // Throttle minumum Reminder gap at 10 min
    return reminderGap.round();
  }

  /// Fetches the [WaterGoal.reminderGap] of current day
  Future<int> getStoredReminderGap() async {
    WaterGoal? todaysGoal = await getGoal(DateTime.now());
    return todaysGoal!.reminderGap;
  }
}
