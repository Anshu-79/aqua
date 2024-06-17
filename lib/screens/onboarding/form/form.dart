import 'package:aqua/screens/onboarding/form/profile_picture.dart';
import 'package:aqua/screens/onboarding/form/sleep_schedule.dart';
import 'package:aqua/screens/onboarding/form/weight.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';

import 'package:aqua/screens/onboarding/form/name.dart';
import 'package:aqua/screens/onboarding/form/email.dart';
import 'package:aqua/screens/onboarding/form/profile.dart';
import 'package:aqua/screens/onboarding/form/sex.dart';
import 'package:aqua/screens/onboarding/form/dob.dart';
import 'package:aqua/screens/onboarding/form/height.dart';

List<Page<dynamic>> onGenerateProfilePages(
  Profile profile,
  List<Page<dynamic>> pages,
) {
  print(profile);
  final pageList = [
    const NameInputScreen(),
    if (profile.name != null) EmailInputScreen(name: profile.name!),
    const SexInputScreen(),
    const DobInputScreen(),
    const HeightInputScreen(),
    const WeightInputScreen(),
    const SleepScheduleInputScreen(),
    const PictureInputScreen(),
  ];
  return [
    MaterialPage<void>(
      child: pageList[profile.currentPage!],
    )
  ];
}

class OnboardingFlow extends StatelessWidget {
  const OnboardingFlow._();

  static Route<Profile> route() {
    return MaterialPageRoute(builder: (_) => const OnboardingFlow._());
  }

  @override
  Widget build(BuildContext context) {
    return const FlowBuilder(
      onGeneratePages: onGenerateProfilePages,
      state: Profile(currentPage: 0),
    );
  }
}
