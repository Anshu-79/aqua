import 'package:flutter/material.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils/colors.dart';
import 'package:aqua/utils/widgets/universal_header.dart';
import 'package:aqua/utils/widgets/universal_fab.dart';
import 'package:aqua/utils/widgets/global_navigator.dart';

import 'package:aqua/screens/beverage_menu/beverage_dialog.dart';
import 'package:aqua/screens/beverage_menu/beverage_card.dart';

class BeverageMenu extends StatefulWidget {
  const BeverageMenu({super.key, required this.database});

  final Database database;

  @override
  State<BeverageMenu> createState() => _BeverageMenuState();
}

class _BeverageMenuState extends State<BeverageMenu> {
  refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const UniversalHeader(title: "My Beverages"),
        body: FutureBuilder<List<Beverage>>(
            future: widget.database.getBeverages(),
            builder: (context, snapshot) {
              final List<Beverage> beverages = snapshot.data ?? [];

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }

              return ListView.builder(
                  itemCount: beverages.length,
                  itemBuilder: (context, index) {
                    return BeverageCard(
                      bvg: beverages[index],
                      db: widget.database,
                      notifyParent: refresh,
                    );
                  });
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: UniversalFAB(
            tooltip: "Add new beverage",
            onPressed: () async {
              final output = await GlobalNavigator.showAnimatedDialog(
                  BeverageDialog(notifyParent: refresh, beverage: null));

              BeveragesCompanion? addedBeverage = output[1];

              if (addedBeverage == null) return;

              List<Beverage> bevList = await widget.database.getBeverages();
              List<String> names = bevList.map((bev) => bev.name).toList();

              if (names.contains(addedBeverage.name.value)) {
                GlobalNavigator.showSnackBar(
                    'This beverage already exists', null);
              } else {
                GlobalNavigator.showSnackBar(
                    'Beverage Added', addedBeverage.colorCode.value.toColor());
                await widget.database.insertOrUpdateBeverage(addedBeverage);
              }
            }));
  }
}

