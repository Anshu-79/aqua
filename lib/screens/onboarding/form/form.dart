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
  return [
    if (profile.currentPage == 1)
      const MaterialPage<void>(child: NameInputScreen(), name: '/profile'),
    if (profile.currentPage == 2)
      MaterialPage<void>(
          child: EmailInputScreen(
        name: profile.name!,
      )),
    if (profile.currentPage == 3)
      const MaterialPage<void>(child: SexInputScreen()),
    if (profile.currentPage == 4)
      const MaterialPage<void>(child: DobInputScreen()),
    if (profile.currentPage == 5)
      const MaterialPage<void>(child: HeightInputScreen()),
      if (profile.currentPage == 6)
      const MaterialPage<void>(child: WeightInputScreen()),
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
      state: Profile(currentPage: 1),
    );
  }
}
