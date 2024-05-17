import 'package:flutter/material.dart';

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
                  const Text(
                    "Anshumaan Tanwar",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "City, State, Country",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: const BorderSide(
                                        color: Colors.white)))),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "18",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30),
                            ),
                            Text("Age",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12))
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: const BorderSide(
                                        color: Colors.white)))),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "175",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30),
                            ),
                            Text("Height",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12))
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: const BorderSide(
                                        color: Colors.white)))),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "64",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30),
                            ),
                            Text("Weight",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12))
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
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.whatshot_rounded,
                                color: Color(0xFFF24E1E), size: 30),
                            SizedBox(width: 10),
                            Text(
                              "7",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w900),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 35,
                            ),
                            Text("Day Streak",
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold)),
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
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.local_drink,
                                color: Color(0xFF699BF7), size: 30),
                            SizedBox(width: 10),
                            Text(
                              "7.9 L",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w900),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 30,
                            ),
                            Text("Weekly Water Intake",
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold)),
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
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.water_drop,
                                color: Color(0xFF0FA958), size: 30),
                            SizedBox(width: 10),
                            Text(
                              "42 L",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w900),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 35,
                            ),
                            Text("Lifetime Intake",
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold)),
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
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.coffee,
                                color: Color(0xFFFFC700), size: 30),
                            SizedBox(width: 10),
                            Text(
                              "10 L",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w900),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 35,
                            ),
                            Text("Weekly Fluid Intake",
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold)),
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
