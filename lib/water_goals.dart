import 'package:aqua/shared_pref_utils.dart';

Future<int> calcTodaysGoal() async {
  final int age = await getAge();
  final String? sex = await SharedPrefUtils.readStr('sex');

  int intake = getAWI(age, sex);

  int rwl = await calcRespiratoryLoss();
  intake += rwl.round(); // Add RWL to the goal to compensate for it

  return intake;
}

Future<int> calcRespiratoryLoss() async {
  final double? altitude = await SharedPrefUtils.readDouble('altitude');
  final double? temperature = await SharedPrefUtils.readDouble('temperature');
  final double mr = await getMR();
  double rwl = 0.107 * mr + 92.2;

  if (altitude! > 4300) rwl += 200;

  if (temperature! < -20 || temperature > 25) rwl += 340;

  return rwl.round();
}

Future<double> calcSweatLoss(double metVal, int duration) async {
  double efficiency = 0.25;

  int? weight = await SharedPrefUtils.readInt('weight');

  double swl = 1.722 * (1 - efficiency) * metVal * weight! * duration / 60;

  return swl;
}

Future<int> getAge() async {
  String? dobStr = await SharedPrefUtils.readStr('DOB');
  return calculateAge(dobStr!);
}

int calculateAge(String dobStr) {
  DateTime dob = DateTime.parse(dobStr);
  DateTime now = DateTime.now();

  int age = now.year - dob.year;

  // Making sure age is correct in case birthday has not occured this year
  if (now.month < dob.month) age--;
  if (now.month == dob.month && now.day < dob.day) age--;

  return age;
}

int getAWI(age, sex) {
  if (sex == 'F') {
    if (1 <= age && age < 4) return 1300;
    if (4 <= age && age < 9) return 1700;
    if (9 <= age && age < 14) return 2100;
    if (14 <= age && age < 19) return 2300;
    if (19 <= age) return 2700;
  } else {
    if (1 <= age && age < 4) return 1300;
    if (4 <= age && age < 9) return 1700;
    if (9 <= age && age < 14) return 2400;
    if (14 <= age && age < 19) return 3300;
    if (19 <= age) return 3700;
  }
  return 0;
}

// Calculates the Basal Metabolic Rate of a user
Future<double> getMR() async {
  int? weight = await SharedPrefUtils.readInt('weight');
  int? height = await SharedPrefUtils.readInt('height');
  String? sex = await SharedPrefUtils.readStr('sex');
  int age = await getAge();

  double mr = 10 * weight! + 6.25 * height! - 5 * age;

  if (sex == 'F') return mr - 161;

  return mr + 5;
}
