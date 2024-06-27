import 'package:cron/cron.dart';

void dayChanger(int wakeTime) {
  final cron = Cron();
  //print("dayChanger started!");

  cron.schedule(Schedule.parse('0 $wakeTime * * *'),
      () async => await Future.delayed(const Duration(seconds: 5)));
}
