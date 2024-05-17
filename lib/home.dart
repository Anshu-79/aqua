import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 125),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Column(
                  children: [
                    Center(
                        child: Text(
                      "Today's Goal",
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    )),
                    Column(
                      children: [
                        Row(
                          children: [
                            Center(
                                child: Text(
                              "0.00",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 76, 170, 246)),
                            )),
                            Column(
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Center(
                                        child: Text(
                                      "/",
                                      style: TextStyle(
                                          fontSize: 60,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    Column(
                                      children: [
                                        SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Center(
                                                child: Text(
                                              "2.00",
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.blueAccent,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Center(
                                                child: Text(
                                              "L",
                                              style: TextStyle(
                                                  fontSize: 70,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 60, 65, 69)),
                                            )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  child: AspectRatio(
                      aspectRatio: 200 / 550,
                      child: const Image(
                          image: AssetImage('assets/images/water_bottle.png'),
                          fit: BoxFit.fill)),
                  height: 200,
                )
              ],
            ),
            const SizedBox(height: 100),
            const Center(
                child: Text(
              "Next reminder in",
              style: TextStyle(fontSize: 30),
            )),
            const Center(
                child: Text(
              "20 minutes",
              style: TextStyle(fontSize: 40, color: Colors.blue),
            )),
            const SizedBox(height: 150),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          tooltip: "Add water",
          onPressed: () {},
          backgroundColor: Colors.black,
          splashColor: Colors.blue,
          shape: const CircleBorder(eccentricity: 0),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 50,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
