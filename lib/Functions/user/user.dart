import 'package:chat_app/Functions/firebase_message_api.dart';
import 'package:chat_app/Functions/toasts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// adding user when signed in
void userAdd() async {
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

  await FirebaseFirestore.instance
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
          .set({
        'name': "Add Name",
        'fcmToken': fCMToken,
        'image_url': "",
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

Future<void> userUpdateProfileImageURL(String imageUrl) async {
  User? user = FirebaseAuth.instance.currentUser;
  String? uuid;
  if (user != null) {
    uuid = user.uid;
  } else {
    showToastMessage("No user is currently authenticated.");
  }

  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc("profiles")
        .collection(uuid!)
        .doc("details")
        .update({'image_url': imageUrl});
    showToastMessage('Image Updated Succesfully');
  } catch (error) {
    showToastMessage('Failed to update image');
    // Handle error
  }
}

Future<String?> getUserProfileUrl(String uuid) async {
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc("profiles")
        .collection(uuid)
        .doc("details")
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        return data['image_url'] as String?;
      } else {
        return null; // Data is null
      }
    } else {
      return null; // User details not found
    }
  } catch (error) {
    print('Error retrieving user profile URL: $error');
    return null;
  }
}

Future<void> userUpdateProfileName(String newName) async {
  User? user = FirebaseAuth.instance.currentUser;
  String? uuid;
  if (user != null) {
    uuid = user.uid;
  } else {
    showToastMessage("No user is currently authenticated.");
  }

  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc("profiles")
        .collection(uuid!)
        .doc("details")
        .update({'name': newName});
    showToastMessage('User name updated successfully');
  } catch (error) {
    showToastMessage('Failed to update user name');
    // Handle error
  }
}
