import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';

import 'package:aqua/utils/widgets/tooltip.dart';
import 'package:aqua/screens/onboarding/form/profile.dart';
import 'package:aqua/screens/onboarding/form/nav_buttons.dart';
import 'package:aqua/utils.dart' as utils;
import 'package:aqua/utils/colors.dart';
import 'package:aqua/shape_painter.dart';

String tooltipMessage =
    "Research indicates that water requirements can vary by around 1 liter between genders.";

class SexInputScreen extends StatefulWidget {
  const SexInputScreen({super.key});

  @override
  State<SexInputScreen> createState() => _SexInputScreenState();
}

class _SexInputScreenState extends State<SexInputScreen> {
  late String selectedSex;

  @override
  void initState() {
    selectedSex = 'F';
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final Profile profile = context.flow<Profile>().state;
    selectedSex = profile.sex ?? selectedSex;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Widget sexRadioButton(String value, Color color, Icon icon) {
      bool isSelected = selectedSex == value;
      return SizedBox(
        height: 140,
        width: 140,
        child: IconButton(
          icon: icon,
          onPressed: () => setState(() => selectedSex = value),
          iconSize: 100,
          style: IconButton.styleFrom(
              backgroundColor: isSelected ? color : color.lighten(30),
              foregroundColor: Colors.white,
              side: BorderSide(color: color, width: 5)),
        ),
      );
    }

    return Scaffold(
        body: Stack(
          children: [
            ColoredShapesBackground(),
            TooltipOnTap(message: tooltipMessage),
            Container(
              margin: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const utils.OnboardingQuestion(
                        text: "And what is your sex?"),
                    const SizedBox(height: 30),
                    Wrap(
                      spacing: 30,
                      alignment: WrapAlignment.center,
                      children: [
                        sexRadioButton(
                            'M', Colors.blue.shade600, const Icon(Icons.male)),
                        sexRadioButton('F', Colors.pink.shade600,
                            const Icon(Icons.female)),
                        sexRadioButton('O', Colors.purple.shade600,
                            const Icon(Icons.transgender)),
                      ],
                    ),
                  ]),
            ),
          ],
        ),
        bottomNavigationBar: NavButtons(navBack: () {
          context.flow<Profile>().update((profile) => profile.decrementPage());
        }, navForward: () {
          context.flow<Profile>().update(
              (profile) => profile.copyWith(sex: selectedSex).incrementPage());
        }));
  }
}
