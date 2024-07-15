import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/utils/colors.dart';
import 'package:aqua/utils/textstyles.dart';
import 'package:aqua/utils/widgets/global_navigator.dart';
import 'package:aqua/utils/weather_utils.dart';

/// This widget displays the user's location
/// It uses the place obtained in the daily weather report
/// The user can manually update the place using a refresh IconButton on this widget
class LocationWidget extends StatefulWidget {
  const LocationWidget({super.key, required this.prefs});
  final SharedPreferences prefs;
  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  @override
  Widget build(BuildContext context) {
    String place = widget.prefs.getString('place')!;

    return LayoutBuilder(builder: (context, constraints) {
      final availableWidth = constraints.maxWidth - 50;
      double iconSize = availableWidth / 3;

      if (iconSize < 20) iconSize = 20;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, color: Colors.white, size: iconSize),
              const SizedBox(width: 10),
              Text(place, style: ProfileScreenStyles.userLocation, maxLines: 1),
              const SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.white, size: iconSize),
                onPressed: () async {
                  GlobalNavigator.showSnackBar(
                      'Updating location...', AquaColors.darkBlue);
        
                  await saveWeather();
                  setState(() {});
                  GlobalNavigator.showSnackBar(
                      'Location updated', AquaColors.darkBlue);
                },
              )
            ],
          ),
        ),
      );
    });
  }
}
