import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:aqua/screens/onboarding/form/nav_buttons.dart';
import 'package:aqua/screens/onboarding/form/profile.dart';
import 'package:aqua/shape_painter.dart';
import 'package:aqua/utils.dart' as utils;

class EmailInputField extends StatefulWidget {
  const EmailInputField(
      {super.key, required this.formKey, required this.controller});

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;

  @override
  State<EmailInputField> createState() => _EmailInputFieldState();
}

class _EmailInputFieldState extends State<EmailInputField> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        style: utils.ThemeText.nameInputField,
        controller: widget.controller,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: "Your Email",
          hintStyle: utils.ThemeText.formHint,
          filled: false,
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor)),
        ),
        validator: (value) {
          if (!EmailValidator.validate(value!)) {
            return "Please enter a valid email address";
          }
          return null;
        },
      ),
    );
  }
}

// Displays the user's name using a shiny animation
class UserName extends StatelessWidget {
  const UserName({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: AnimatedTextKit(
        repeatForever: true,
        animatedTexts: [
          ColorizeAnimatedText(
            name,
            textStyle:
                const TextStyle(fontSize: 60, fontWeight: FontWeight.w900),
            textAlign: TextAlign.center,
            colors: utils.textColorizeColors,
            speed: const Duration(milliseconds: 500),
          ),
        ],
      ),
    );
  }
}

class EmailInputScreen extends StatefulWidget {
  const EmailInputScreen({super.key});

  @override
  State<EmailInputScreen> createState() => _EmailInputScreenState();
}

class _EmailInputScreenState extends State<EmailInputScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Profile profile = context.flow<Profile>().state;
    TextEditingController emailController =
        TextEditingController(text: profile.email ?? "");

    return Scaffold(
        body: Stack(
          children: [
            ColoredShapesBackground(),
            Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Nice to have you,",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w900)),
                    UserName(name: profile.name!),
                    const SizedBox(height: 75),
                    EmailInputField(
                        formKey: formKey, controller: emailController),
                  ]),
            ),
          ],
        ),
        bottomNavigationBar: NavButtons(navBack: () {
          context.flow<Profile>().update((profile) => profile.decrementPage());
        }, navForward: () {
          if (formKey.currentState!.validate()) {
            context.flow<Profile>().update((profile) =>
                profile.copyWith(email: emailController.text.trim()).incrementPage());
          }
        }));
  }
}
