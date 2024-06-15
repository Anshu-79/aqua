import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:aqua/screens/onboarding/form/nav_buttons.dart';
import 'package:aqua/screens/onboarding/form/profile.dart';
import 'package:aqua/shape_painter.dart';
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
        body: Stack(
          children: [
            ColoredShapesBackground(),
            Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "Nice to have you,",
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.w900),
                        ),
                        FittedBox(
                          fit: BoxFit.contain,
                          child: AnimatedTextKit(
                            repeatForever: true,
                            animatedTexts: [
                              ColorizeAnimatedText(
                                widget.name,
                                textStyle: const TextStyle(
                                    fontSize: 60, fontWeight: FontWeight.w900),
                                textAlign: TextAlign.center,
                                colors: utils.textColorizeColors,
                                speed: const Duration(milliseconds: 500),
                              ),
                            ],
                          ),
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
                          keyboardType: TextInputType.emailAddress,
                          style: utils.ThemeText.nameInputField,
                          controller: emailController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "Your Email",
                            hintStyle: utils.ThemeText.formHint,
                            filled: false,
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor)),
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
          ],
        ),
        bottomNavigationBar: NavButtons(navBack: () {
          context.flow<Profile>().update((profile) => profile.decrementPage());
        }, navForward: () {
          if (formKey.currentState!.validate()) {
            context.flow<Profile>().update((profile) =>
                profile.copyWith(email: emailController.text).incrementPage());
          }
        }));
  }
}
