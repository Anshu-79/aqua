import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:aqua/screens/onboarding/form/name.dart';
import 'package:aqua/screens/onboarding/form/profile.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

import 'package:aqua/utils.dart' as utils;

class EmailInputScreen extends StatefulWidget {
  const EmailInputScreen({super.key, required this.name});
  final String name;

  @override
  State<EmailInputScreen> createState() => _EmailInputScreenState();
}

class _EmailInputScreenState extends State<EmailInputScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(
            children: [
              const Text(
                "Nice to have you,",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
              ),
              AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  ColorizeAnimatedText(
                    widget.name,
                    textStyle:
                        const TextStyle(fontSize: 60, fontWeight: FontWeight.w900),
                    textAlign: TextAlign.center,
                    colors: utils.textColorizeColors,
                    speed: const Duration(milliseconds: 500),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 75,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: formKey,
              child: TextFormField(
                style: utils.ThemeText.nameInputField,
                controller: emailController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Your Email",
                  hintStyle: utils.ThemeText.formHint,
                  filled: false,
                  border: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                ),
                validator: (value) {
                  if (!EmailValidator.validate(value!)) {
                    return "Please enter a valid email address";
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
        ]),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton.filled(
              icon: const Icon(Icons.chevron_left),
              iconSize: 50,
              style: IconButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NameInputScreen()));
              },
            ),
            IconButton.filled(
              icon: const Icon(Icons.chevron_right),
              iconSize: 50,
              style: IconButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final email = emailController.text;
                  context.flow<Profile>().update((profile) => profile.copyWith(email: email));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
