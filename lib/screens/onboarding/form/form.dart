import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';

import 'package:aqua/screens/onboarding/form/name.dart';
import 'package:aqua/screens/onboarding/form/email.dart';
import 'package:aqua/screens/onboarding/form/profile.dart';
import 'package:aqua/screens/onboarding/form/sex.dart';

class OnboardingForm extends StatefulWidget {
  const OnboardingForm({super.key});

  @override
  State<OnboardingForm> createState() => _OnboardingFormState();
}

class _OnboardingFormState extends State<OnboardingForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Placeholder(),
    );
  }
}

List<Page<dynamic>> onGenerateProfilePages(
  Profile profile,
  List<Page<dynamic>> pages,
) {
  return [
    const MaterialPage<void>(child: NameInputScreen(), name: '/profile'),
    if (profile.name != null)
      MaterialPage<void>(
          child: EmailInputScreen(
        name: profile.name!,
      )),
    if (profile.email != null)
      const MaterialPage<void>(child: SexInputScreen()),
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
      state: Profile(),
    );
  }
}
