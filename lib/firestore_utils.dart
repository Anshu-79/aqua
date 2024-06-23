import 'dart:io';

import 'package:aqua/shared_pref_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

import 'package:aqua/screens/onboarding/form/profile.dart';

Future<void> createUser(Profile profile, List<double?> location) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  users.add({
    'name': profile.name,
    'email': profile.email,
    'sex': profile.sex,
    'DOB': profile.dob,
    'height': profile.height,
    'weight': profile.weight,
    'sleepTime': profile.sleepTime,
    'wakeTime': profile.wakeTime,
    'streak': 0,
    'location': GeoPoint(location[0]!, location[1]!),
  }).then(
      (DocumentReference doc) async => SharedPrefUtils.saveStr('uid', doc.id));
}

Future<void> uploadProfilePicture(File? image, String username) async {
  final folderRef = FirebaseStorage.instance.ref().child('profile_pictures');

  String uid = await SharedPrefUtils.readPrefStr('uid') ?? username;

  final imageRef = folderRef.child(uid);

  if (image == null) return;

  try {
    await imageRef.putFile(image);
  } on FirebaseException catch (e) {
    Future.error(e);
  }
}

Future<void> saveProfilePictureLocally(File? image, String username) async {
  if (image == null) return;
  
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$username.png';

  final newfile = await image.copy(filePath);

  SharedPrefUtils.saveStr('photo_path', newfile.path);
  
}
