import 'package:cron/cron.dart';

void dayChanger(double wakeTime) {
  final cron = Cron();
  //print("dayChanger started!");

  int hrs = wakeTime.truncate();
  int minutes = (wakeTime - hrs).ceil() * 30;

  cron.schedule(Schedule.parse('$minutes $hrs * * *'),
      () async => await Future.delayed(const Duration(seconds: 5)));
}
