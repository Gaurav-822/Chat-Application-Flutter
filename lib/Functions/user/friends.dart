import 'package:chat_app/Functions/toasts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void addFriend(String friendUuid) async {
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
      .doc("relations")
      .collection("friends")
      .add({
    'uuid': friendUuid,
  }).then((DocumentReference docRef) {
    debugPrint("Friend added @: ${docRef.id}");
  }).catchError((error) {
    showToastMessage("Failed to add, retry. . .");

    throw ("Failed to add: $error");
  });
}

Future<void> setFriendsLocally() async {
  User? user = FirebaseAuth.instance.currentUser;
  List<String> friendList = [];

  if (user != null) {
    String uuid = user.uid;

    QuerySnapshot friendsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc("profiles")
        .collection(uuid)
        .doc("relations")
        .collection("friends")
        .get();

    friendList = friendsSnapshot.docs
        .map((doc) => doc.get('uuid'))
        .toList()
        .cast<String>();
    // update local pref
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('friends', friendList);
  } else {
    // Handle the case where there's no authenticated user
    print("No user is currently authenticated.");
  }
}
