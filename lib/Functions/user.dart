import 'package:chat_app/Functions/firebase_message_api.dart';
import 'package:chat_app/Functions/profile_function.dart';
import 'package:chat_app/Functions/toasts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void UserAdd(String username, image_url) async {
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
      .collection(username)
      .doc("details")
      .collection("admin")
      .where('username', isEqualTo: username)
      .get()
      .then((QuerySnapshot querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        doc.reference.update({
          'name': username,
          'fcmToken': fCMToken,
          'uuid': uuid,
          'image_url': image_url,
        }).then((_) {
          return getProfilePicUrl(username);
        }).catchError((error) {
          showToastMessage("Failed to update: $error");

          debugPrint("Failed to update: $error");
          throw ("Failed to update: $error");
        });
      }
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc("profiles")
          .collection(username)
          .doc("details")
          .collection("admin")
          .add({
        'name': username,
        'fcmToken': fCMToken,
        'uuid': uuid,
        'image_url': image_url,
      }).then((DocumentReference docRef) {
        debugPrint("Profile for $username added @: ${docRef.id}");
        return getProfilePicUrl(username);
      }).catchError((error) {
        showToastMessage("Failed to add profile for $username, retry. . .");

        throw ("Failed to add profile: $error");
      });
    }
  }).catchError((error) {
    showToastMessage(
        "Some error occured, chek your internet connection and try again!");

    debugPrint("Error fetching document: $error");
  });
}
