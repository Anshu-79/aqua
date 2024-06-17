import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:aqua/screens/onboarding/form/profile.dart';
import 'package:aqua/screens/onboarding/form/nav_buttons.dart';
import 'package:aqua/shape_painter.dart';
import 'package:aqua/utils.dart' as utils;

class PictureInputScreen extends StatefulWidget {
  const PictureInputScreen({super.key});

  @override
  State<PictureInputScreen> createState() => _PictureInputScreenState();
}

class _PictureInputScreenState extends State<PictureInputScreen> {
  File? _image;
  dynamic placeholderImg;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null) {
      placeholderImg = const AssetImage('assets/images/selfie.gif');
    } else {
      placeholderImg = FileImage(_image!);
    }

    return Scaffold(
        body: Stack(
          children: [
            ColoredShapesBackground(),
            Container(
              margin: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedTextKit(
                      totalRepeatCount: 1,
                      animatedTexts: [
                        TypewriterAnimatedText(
                          "Mind sharing your photo?",
                          textStyle: const TextStyle(
                              fontSize: 40, fontWeight: FontWeight.w800),
                          textAlign: TextAlign.center,
                          cursor: '|',
                          speed: const Duration(milliseconds: 100),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: CircleAvatar(
                          radius: 150,
                          backgroundColor: Theme.of(context).canvasColor,
                          backgroundImage: placeholderImg),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: utils.defaultColors['dark blue'],
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text(
                                      "Pick Profile Picture",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          _pickImage(ImageSource.gallery);
                                        },
                                        child: const Text("Gallery",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          _pickImage(ImageSource.camera);
                                        },
                                        child: const Text("Camera",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  ));
                        },
                        child: const Text("Choose a picture")),
                    const SizedBox(
                      height: 20,
                    ),
                  ]),
            ),
          ],
        ),
        bottomNavigationBar: NavButtons(navBack: () {
          context.flow<Profile>().update((profile) => profile.decrementPage());
        }, navForward: () {
          context
              .flow<Profile>()
              .complete((profile) => profile.copyWith(picture: _image).incrementPage());
        }));
  }
}
