import 'package:flutter/material.dart';

import 'package:aqua/icomoon_icons.dart';
import 'package:aqua/utils.dart' as utils;

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(
                    color: Colors.blue,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(35))),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  IconButton(
                      iconSize: 100,
                      icon: const Icon(
                        Icons.account_circle_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {}),
                  Text(
                    "Anshumaan Tanwar",
                    style: utils.ThemeText.username,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "City, State, Country",
                        style: utils.ThemeText.userLocationSubtext,
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: const BorderSide(color: Colors.white))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "18",
                              style: utils.ThemeText.userInfo,
                            ),
                            Text("Age", style: utils.ThemeText.userInfoSubtext)
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: const BorderSide(color: Colors.white))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "175",
                              style: utils.ThemeText.userInfo,
                            ),
                            Text("Height",
                                style: utils.ThemeText.userInfoSubtext)
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: const BorderSide(color: Colors.white))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "64",
                              style: utils.ThemeText.userInfo,
                            ),
                            Text("Weight",
                                style: utils.ThemeText.userInfoSubtext)
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30)
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 60,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFF24E1E),
                      width: 3,
                    ),
                    color: const Color(0x73FF9A62),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.whatshot_rounded,
                                color: Color(0xFFF24E1E), size: 30),
                            const SizedBox(width: 10),
                            Text(
                              "7",
                              style: utils.ThemeText.userStats,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 35,
                            ),
                            Text("Day Streak",
                                style: utils.ThemeText.userStatsSubtext),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF699BF7),
                      width: 3,
                    ),
                    color: const Color(0x66699BF7),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icomoon.water_glass,
                                color: Color(0xFF699BF7), size: 30),
                            const SizedBox(width: 10),
                            Text(
                              "7.9 L",
                              style: utils.ThemeText.userStats,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 30,
                            ),
                            Text("Weekly Water Intake",
                                style: utils.ThemeText.userStatsSubtext),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 60,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF0FA958),
                      width: 3,
                    ),
                    color: const Color(0x4D0FA958),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_month_outlined,
                                color: Color(0xFF0FA958), size: 30),
                            const SizedBox(width: 10),
                            Text(
                              "42 L",
                              style: utils.ThemeText.userStats,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 35,
                            ),
                            Text("Lifetime Intake",
                                style: utils.ThemeText.userStatsSubtext),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFFFC700),
                      width: 3,
                    ),
                    color: const Color(0x4DFFC700),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icomoon.tea_cup,
                                color: Color(0xFFFFC700), size: 28),
                            const SizedBox(width: 10),
                            Text(
                              "10 L",
                              style: utils.ThemeText.userStats,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 35,
                            ),
                            Text("Weekly Fluid Intake",
                                style: utils.ThemeText.userStatsSubtext),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
