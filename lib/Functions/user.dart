import 'package:chat_app/Functions/firebase_message_api.dart';
import 'package:chat_app/Functions/toasts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// adding user when signed in
void UserAdd() async {
  // sets [username, name, messageAPI, UUID]

  //get messageAPI
  FirebaseMessageApi firebaseMessageApi = FirebaseMessageApi();
  String? fCMToken = await firebaseMessageApi.initNotification();

  User? user = FirebaseAuth.instance.currentUser;
  String? uuid;
  if (user != null) {
    uuid = user.uid;
  } else {
    showToastMessage("No user is currently authenticated.");
  }

  FirebaseFirestore.instance
      .collection('users')
      .doc("profiles")
      .collection(uuid!)
      .where('details', isEqualTo: uuid)
      .get()
      .then((QuerySnapshot querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        doc.reference
            .update({
              // 'name': name,
              'fcmToken': fCMToken,
              'image_url': "",
            })
            .then((_) {})
            .catchError((error) {
              showToastMessage("Failed to update: $error");

              debugPrint("Failed to update: $error");
              throw ("Failed to update: $error");
            });
      }
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc("profiles")
          .collection(uuid!)
          .doc("details")
          .collection("admin")
          .add({
        'name': "Add Name",
        'fcmToken': fCMToken,
        'image_url': "",
      }).then((DocumentReference docRef) {
        debugPrint("Profile added @: ${docRef.id}");
      }).catchError((error) {
        showToastMessage("Failed to add profile, retry. . .");

        throw ("Failed to add profile: $error");
      });
    }
  }).catchError((error) {
    showToastMessage(
        "Some error occured, chek your internet connection and try again!");

    debugPrint("Error fetching document: $error");
  });
}

Future<void> UserUpdateProfileImageURL(String uuid, String imageUrl) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc("profiles")
        .collection(uuid)
        .doc("details")
        .collection("admin")
        .doc("details")
        .update({
      'image_url': imageUrl,
    });
    debugPrint("Profile image URL updated for UUID: $uuid");
  } catch (error) {
    showToastMessage("Failed to update profile image URL for UUID: $uuid");
    debugPrint(
        "Failed to update profile image URL for UUID: $uuid, Error: $error");
    throw ("Failed to update profile image URL for UUID: $uuid, Error: $error");
  }
}

Future<void> UserUpdateProfileName(String uuid, String newName) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc("profiles")
        .collection(uuid)
        .doc("details")
        .collection("admin")
        .doc(
            "details") // Assuming this is the document where the name is stored
        .update({
      'name': newName,
    });
    debugPrint("Profile name updated for UUID: $uuid");
  } catch (error) {
    showToastMessage("Failed to update profile name for UUID: $uuid");
    debugPrint("Failed to update profile name for UUID: $uuid, Error: $error");
    throw ("Failed to update profile name for UUID: $uuid, Error: $error");
  }
}
