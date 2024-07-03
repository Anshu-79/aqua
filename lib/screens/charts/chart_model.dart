import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// Draws a border around the chart
// Displays a Progress Indicator while the chart loads
class GenericChart<T> extends StatelessWidget {
  const GenericChart({
    super.key,
    required this.headerText,
    required this.dataFuture,
    required this.chartBuilder,
  });

  final String headerText;
  final Future<T> dataFuture;
  final Widget Function(T) chartBuilder;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor.computeLuminance() > 0.5
              ? Colors.grey.shade200
              : Colors.grey.shade900,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Theme.of(context).primaryColor, width: 5),
        ),
        child: FutureBuilder<T>(
            future: dataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildShimmerEffect();
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          headerText,
                          style: const TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 40),
                        )),
                    const SizedBox(height: 20),
                    AspectRatio(
                      aspectRatio: 2.0,
                      child: chartBuilder(snapshot.data as T),
                    )
                  ]);
            }));
  }

  Widget _buildShimmerEffect() {
    bool isDarkMode =
        PlatformDispatcher.instance.platformBrightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
      highlightColor: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Container(width: 200, height: 40, color: Colors.white),
        const SizedBox(height: 20),
        Container(width: double.infinity, height: 150, color: Colors.white),
      ]),
    );
  }
}
