import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';

import 'package:aqua/utils.dart' as utils;
import 'package:aqua/shape_painter.dart';
import 'package:aqua/screens/onboarding/form/profile.dart';

class NameInputScreen extends StatefulWidget {
  const NameInputScreen({super.key});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ColoredShapesBackground(),
          Container(
            margin: const EdgeInsets.all(10),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  TypewriterAnimatedText(
                    "What do we call you?",
                    textStyle: const TextStyle(
                        fontSize: 50, fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                    cursor: '|',
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
              ),
              const SizedBox(
                height: 75,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    style: utils.ThemeText.nameInputField,
                    controller: nameController,
                    textCapitalization: TextCapitalization.words,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "Your Name",
                      hintStyle: utils.ThemeText.formHint,
                      filled: false,
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor)),
                    ),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return "Name cannot be empty";
                      } else if (value.length > 100) {
                        return "Please enter a valid name";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
            ]),
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
                  final name = nameController.text;
                  context.flow<Profile>().update((profile) =>
                      profile.copyWith(name: name).incrementPage());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}