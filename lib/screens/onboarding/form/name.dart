import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';

import 'package:aqua/utils/miscellaneous.dart' as utils;
import 'package:aqua/shape_painter.dart';
import 'package:aqua/screens/onboarding/form/profile.dart';

/// The [NameInputScreen] uses a [TextFormField] for name entry
class NameInputScreen extends StatefulWidget {
  const NameInputScreen({super.key});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Profile profile = context.flow<Profile>().state;
    TextEditingController nameController =
        TextEditingController(text: profile.name ?? "");

    return Scaffold(
        body: Stack(
          children: [
            const ColoredShapesBackground(),
            Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const utils.OnboardingQuestion(text: "What do we call you?"),
                  const SizedBox(height: 75),
                  NameInputField(formKey: formKey, controller: nameController),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton.filled(
                      icon: const Icon(Icons.chevron_right),
                      iconSize: 50,
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Theme.of(context).canvasColor,
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          final name = nameController.text.trim();

                          context.flow<Profile>().update((profile) =>
                              profile.copyWith(name: name).incrementPage());
                        }
                      })
                ])));
  }
}

/// Text field to receive username
class NameInputField extends StatefulWidget {
  const NameInputField(
      {super.key, required this.formKey, required this.controller});

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;

  @override
  State<NameInputField> createState() => _NameInputFieldState();
}

class _NameInputFieldState extends State<NameInputField> {
  TextStyle formHintStyle = const TextStyle(
      fontSize: 40, fontWeight: FontWeight.bold, color: Colors.grey);

  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formKey,
        child: TextFormField(
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
            controller: widget.controller,
            textCapitalization: TextCapitalization.words,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: "Your Name",
              hintStyle: formHintStyle,
              filled: false,
              border: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).primaryColor)),
            ),
            validator: (value) {
              if (value!.trim().isEmpty) {
                return "Name cannot be empty";
              } else if (value.length > 100) {
                return "Please enter a valid name";
              } else {
                return null;
              }
            }));
  }
}
