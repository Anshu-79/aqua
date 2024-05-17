import 'package:flutter/material.dart';

class BeverageMenu extends StatefulWidget {
  const BeverageMenu({super.key});

  @override
  State<BeverageMenu> createState() => _BeverageMenuState();
}

class _BeverageMenuState extends State<BeverageMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Padding(
              padding: EdgeInsets.only(top: 50, bottom: 30),
              child: Text(
                "My Beverages",
                style: TextStyle(fontSize: 45, fontWeight: FontWeight.w900),
              ),
            ),
            Card(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              elevation: 0,
              color: Colors.blue.withOpacity(0.3),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  side: BorderSide(color: Colors.blue, width: 5)),
              child: const _BeverageCard(
                beverageName: "Water",
                beverageColor: Colors.blue,
                waterFraction: 1.0,
              ),
            ),
            Card(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              elevation: 0,
              color: const Color(0xFFFFC700).withOpacity(0.3),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  side: BorderSide(color: Color(0xFFFFC700), width: 5)),
              child: const _BeverageCard(
                beverageName: "Coffee",
                beverageColor: Color(0xFFFFC700),
                waterFraction: 0.8,
              ),
            ),
            Card(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              elevation: 0,
              color: const Color(0xFFF24E1E).withOpacity(0.3),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  side: BorderSide(color: Color(0xFFF24E1E), width: 5)),
              child: const _BeverageCard(
                beverageName: "Cola",
                beverageColor: Color(0xFFF24E1E),
                waterFraction: 0.4,
              ),
            ),
            
          ]),
        ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
              onPressed: () {},
              tooltip: "Add new beverage",
              backgroundColor: Colors.black,
              splashColor: Colors.blue,
              shape: const CircleBorder(eccentricity: 0),
              child: const Icon(Icons.add, color: Colors.white, size: 50,),
            ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _BeverageCard extends StatelessWidget {
  const _BeverageCard(
      {required this.beverageName,
      required this.beverageColor,
      required this.waterFraction});
  final String beverageName;
  final Color beverageColor;
  final double waterFraction;

  Icon beverageIcon({required Color color}) {
    return Icon(
      Icons.local_drink,
      color: color,
      size: 60,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
      child: Row(
        children: [
          beverageIcon(color: beverageColor),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  beverageName,
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Water Percentage",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                ),
                Text(
                  '${(waterFraction * 100).toString()}%',
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
