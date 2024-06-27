import 'package:aqua/shared_pref_utils.dart';
import 'package:aqua/weather_utils.dart';
import 'package:drift/drift.dart' as drift;
import 'package:aqua/database/database.dart';
import 'package:flutter/material.dart' show DateUtils;

Future<void> setTodaysGoal() async {
  final Database db = Database();
  final int totalIntake = await findTodaysGoal();

  DateTime now = DateUtils.dateOnly(DateTime.now());

  final goal = WaterGoalsCompanion(
      date: drift.Value(now),
      totalVolume: drift.Value(totalIntake),
      consumedVolume: const drift.Value(0));

  await db.insertOrUpdateGoal(goal);
  await db.close();
}

Future<int> findTodaysGoal() async {
  final int age = await getAge();
  final String? sex = await SharedPrefUtils.readPrefStr('sex');
  final double? altitude = await SharedPrefUtils.readPrefDouble('altitude');

  int intake = getAWI(age, sex);

  // Calculating Respiratory Water Loss (RWL)
  final double mr = await getMR();
  final double rwl = 0.107 * mr + 92.2;

  intake += rwl.round(); // Adding RWL to the goal to compensate for it

  if (altitude! > 4300) intake += 200;

  double temperature = await getTemperature();
  if (temperature < -20 || temperature > 25) intake += 340;

  return intake;
}

// TODO: Complete this!
Future<int> getReminderGap() async {
  final int goal = await findTodaysGoal();
  return 0;
}

Future<int> getAge() async {
  String? dobStr = await SharedPrefUtils.readPrefStr('DOB');
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
  int awi = 0;
  if (sex == 'F') {
    if (1 <= age && age < 4) awi = 1300;
    if (4 <= age && age < 9) awi = 1700;
    if (9 <= age && age < 14) awi = 2100;
    if (14 <= age && age < 19) awi = 2300;
    if (19 <= age && age < 31) awi = 2700;
    if (31 <= age && age < 51) awi = 2700;
    if (51 <= age && age < 71) awi = 2700;
    if (71 <= age) awi = 2700;
  } else {
    if (1 <= age && age < 4) awi = 1300;
    if (4 <= age && age < 9) awi = 1700;
    if (9 <= age && age < 14) awi = 2400;
    if (14 <= age && age < 19) awi = 3300;
    if (19 <= age && age < 31) awi = 3700;
    if (31 <= age && age < 51) awi = 3700;
    if (51 <= age && age < 71) awi = 3700;
    if (71 <= age) awi = 3700;
  }

  return awi;
}

// Calculates the Basal Metabolic Rate of a user
Future<double> getMR() async {
  int? weight = await SharedPrefUtils.readPrefInt('weight');
  int? height = await SharedPrefUtils.readPrefInt('height');
  String? sex = await SharedPrefUtils.readPrefStr('sex');
  int age = await getAge();

  double mr = 10 * weight! + 6.25 * height! - 5 * age;

  if (sex == 'F') return mr - 161;

  return mr + 5;
}
