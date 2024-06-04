import 'package:aqua/icomoon_icons.dart';
import 'package:flutter/material.dart';

import 'package:aqua/database/database.dart';
import 'package:aqua/utils.dart' as utils;

class ListBeverages extends StatefulWidget {
  const ListBeverages({super.key});

  @override
  State<ListBeverages> createState() => _ListBeveragesState();
}

class _ListBeveragesState extends State<ListBeverages> {
  late Database _db;

  @override
  void initState() {
    _db = Database();
    super.initState();
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icomoon.glass_drink),
      iconColor: Theme.of(context).primaryColor,
      backgroundColor: Theme.of(context).canvasColor,
      title: const Text(
        "Select Beverage",
      ),
      titleTextStyle: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 30,
          fontWeight: FontWeight.bold,
          fontFamily: 'CeraPro'),
      //icon: Icon(Icons.check),
      content: Container(
        height: 225,
        child: FutureBuilder<List<Beverage>>(
            future: _db.getBeverages(),
            builder: (context, snapshot) {
              final List<Beverage>? beverages = snapshot.data;

              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }

              if (beverages != null) {
                return Scrollbar(
                  radius: const Radius.circular(30),
                  thickness: 5,
                  child: ListView.builder(
                    itemCount: beverages.length,
                    itemBuilder: (context, index) {
                      final beverage = beverages[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Tooltip(
                          message: beverage.bevName,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color:
                                            utils.toColor(beverage.colorCode),
                                        width: 5),
                                    borderRadius: BorderRadius.circular(20)),
                                backgroundColor: utils.lighten(
                                    utils.toColor(beverage.colorCode), 50)),
                            child: Text(
                              beverage.bevName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: utils.ThemeText.ListBeverageName,
                            ),
                            onPressed: () {
                              Navigator.pop(context, beverage);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const Placeholder();
              }
            }),
      ),
    );
  }
}
