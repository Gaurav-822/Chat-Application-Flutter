import 'dart:io';

import 'package:chat_app/Functions/firebase_message_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

void showToastMessage(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

Future<String?> getProfilePicUrl(String name) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc('profile')
        .collection('admin')
        .where('name', isEqualTo: name)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data()['url'] as String?;
    } else {
      debugPrint('No profile pic found for $name');
      return null;
    }
  } catch (error) {
    debugPrint('Error retrieving profile pic: $error');
    return null;
  }
}

void updateApiToken(String name) async {
  FirebaseMessageApi firebaseMessageApi = FirebaseMessageApi();

  String? fCMToken = await firebaseMessageApi.initNotification();

  FirebaseFirestore.instance
      .collection('users')
      .doc("profile")
      .collection("admin")
      .where('name', isEqualTo: name)
      .get()
      .then((QuerySnapshot querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        doc.reference.update({
          'fcmToken': fCMToken // Updating FCM Token here
        }).then((_) {
          showToastMessage("API token for $name updated");

          debugPrint("API token for $name updated");
        }).catchError((error) {
          showToastMessage("Failed to update API token: $error");

          debugPrint("Failed to update API token: $error");
          throw ("Failed to update API token: $error");
        });
      }
    } else {
      showToastMessage("No user found with the name $name");

      debugPrint("No user found with the name $name");
    }
  }).catchError((error) {
    showToastMessage(
        "Some error occurred, check your internet connection and try again!");

    debugPrint("Error fetching document: $error");
  });
}

void addUserNameAndFCMToken(String name) async {
  FirebaseMessageApi firebaseMessageApi = FirebaseMessageApi();
  // For Device token
  String? fCMToken = await firebaseMessageApi.initNotification();

  FirebaseFirestore.instance
      .collection('users')
      .doc("profile")
      .collection("admin")
      .where('name', isEqualTo: name)
      .get()
      .then((QuerySnapshot querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      debugPrint("User with name $name already exists, no change needed");
      showToastMessage("User with name $name already exists");
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc("profile")
          .collection("admin")
          .add({
        'name': name,
        'fcmToken': fCMToken,
      }).then((DocumentReference docRef) {
        debugPrint("Name and FCM token added for $name @: ${docRef.id}");
        showToastMessage("Name and FCM token added for $name");
      }).catchError((error) {
        showToastMessage(
            "Failed to add name and FCM token for $name, retry...");
        throw ("Failed to add name and FCM token: $error");
      });
    }
  }).catchError((error) {
    showToastMessage(
        "Some error occurred, check your internet connection and try again!");
    debugPrint("Error fetching document: $error");
  });
}

void addUserImageUrl(String name, String imageUrl) async {
  FirebaseFirestore.instance
      .collection('users')
      .doc("profile")
      .collection("admin")
      .where('name', isEqualTo: name)
      .get()
      .then((QuerySnapshot querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        doc.reference.update({
          'url': imageUrl,
        }).then((_) {
          debugPrint("Image URL for $name updated");
          showToastMessage("Image URL for $name updated");
        }).catchError((error) {
          showToastMessage("Failed to update image URL for $name: $error");
          throw ("Failed to update image URL for $name: $error");
        });
      }
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc("profile")
          .collection("admin")
          .add({
        'name': name,
        'url': imageUrl,
      }).then((DocumentReference docRef) {
        debugPrint("Image URL for $name added @: ${docRef.id}");
        showToastMessage("Image URL for $name added");
      }).catchError((error) {
        showToastMessage("Failed to add image URL for $name, retry...");
        throw ("Failed to add image URL for $name: $error");
      });
    }
  }).catchError((error) {
    showToastMessage(
        "Some error occurred, check your internet connection and try again!");
    debugPrint("Error fetching document: $error");
  });
}

void addUser(String name, String url) async {
  FirebaseMessageApi firebaseMessageApi = FirebaseMessageApi();

  // For Device token
  String? fCMToken = await firebaseMessageApi.initNotification();

  FirebaseFirestore.instance
      .collection('users')
      .doc("profile")
      .collection("admin")
      .where('name', isEqualTo: name)
      .get()
      .then((QuerySnapshot querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        doc.reference.update({
          'url': url,
          'fcmToken': fCMToken // Adding FCM Token here
        }).then((_) {
          showToastMessage("Profile pic for $name updated");

          debugPrint("Profile pic for $name updated");
          return getProfilePicUrl(name);
        }).catchError((error) {
          showToastMessage("Failed to update profile pic: $error");

          debugPrint("Failed to update profile pic: $error");
          throw ("Failed to update profile pic: $error");
        });
      }
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc("profile")
          .collection("admin")
          .add({
        'name': name,
        'url': url,
        'fcmToken': fCMToken // Adding FCM Token here
      }).then((DocumentReference docRef) {
        debugPrint("Profile pic for $name added @: ${docRef.id}");
        return getProfilePicUrl(name);
      }).catchError((error) {
        showToastMessage("Failed to add profile pic for $name, retry. . .");

        throw ("Failed to add profile pic: $error");
      });
    }
  }).catchError((error) {
    showToastMessage(
        "Some error occured, chek your internet connection and try again!");

    debugPrint("Error fetching document: $error");
  });
}

Future<void> pickAndUploadImage(profileName, bool gallery) async {
  final picker = ImagePicker();
  String? imageUrl;
  try {
    final pickedFile = (gallery)
        ? await picker.pickImage(source: ImageSource.gallery)
        : await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      // Crop the picked image
      final croppedFile = await _cropImage(imageFile: File(pickedFile.path));

      showToastMessage("Profile pic setting for $profileName");

      if (croppedFile != null) {
        final imageRef =
            FirebaseStorage.instance.ref().child('images/$profileName.jpg');
        await imageRef.putFile(croppedFile);
        imageUrl = await imageRef.getDownloadURL();

        return addUser(profileName, imageUrl);
      }
    }
  } on FirebaseException catch (e) {
    debugPrint('Firebase error: $e');
  } catch (e) {
    debugPrint('Other error: $e');
  }
}

Future<File?> _cropImage({required File imageFile}) async {
  CroppedFile? croppedImage =
      await ImageCropper().cropImage(sourcePath: imageFile.path);
  if (croppedImage == null) return null;
  return File(croppedImage.path);
}
