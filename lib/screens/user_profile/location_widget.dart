import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aqua/utils/colors.dart';
import 'package:aqua/utils/textstyles.dart';
import 'package:aqua/utils/widgets/global_navigator.dart';
import 'package:aqua/utils/weather_utils.dart';

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

    return TextButton(
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_on, color: Colors.white),
          const SizedBox(width: 10),
          Text(place, style: ProfileScreenStyles.userLocation),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
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
    );
  }
}
