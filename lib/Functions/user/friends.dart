import 'dart:convert';

import 'package:chat_app/Functions/toasts.dart';
import 'package:chat_app/Functions/user/get_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void addFriend(String friendUuid) async {
  User? user = FirebaseAuth.instance.currentUser;
  String? uuid;
  if (user != null) {
    uuid = user.uid;
  } else {
    showToastMessage("No user is currently authenticated.");
    return;
  }

  String name = await getUserName(friendUuid) ?? "Name not set";

  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc("profiles")
        .collection(uuid)
        .doc("relations")
        .update({
      // Use FieldValue.serverTimestamp() if you want to add a timestamp
      'friends.$friendUuid': {
        'name': name,
        'uuid': friendUuid,
      }
    }).then((_) {
      showToastMessage("Friend added successfully");
    });
  } catch (error) {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc("profiles")
          .collection(uuid)
          .doc("relations")
          .set({
        'friends.$friendUuid': {
          'name': name,
          'uuid': friendUuid,
        }
      }).then((_) {
        showToastMessage("Friend added successfully");
      });
    } catch (error) {
      showToastMessage("Failed to add friend: $error");
      throw ("Failed to add friend: $error");
    }
  }
}

void setFriendsLocally() async {
  User? user = FirebaseAuth.instance.currentUser;
  String? uuid;
  List<List<String>> friendsList = [];

  if (user != null) {
    uuid = user.uid;
  } else {
    showToastMessage("No user is currently authenticated.");
    return null;
  }

  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc("profiles")
        .collection(uuid)
        .doc("relations")
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? friendsData = snapshot.data()?['friends'];

      if (friendsData != null) {
        friendsData.forEach((key, value) {
          friendsList.add([
            value['name'],
            value['uuid'],
          ]);
        });
      }
    }

    saveNestedData(friendsList);
    // return friendsList;
  } catch (error) {
    showToastMessage("Failed to fetch friends: $error");
    throw ("Failed to fetch friends: $error");
  }
}

// methods to save and retrieve nested list data
void saveNestedData(List<List<String>> nestedList) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> nestedJsonList =
      nestedList.map((list) => json.encode(list)).toList();
  await prefs.setStringList('nestedList', nestedJsonList);
}

Future<List<List<String>>> getNestedData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? nestedJsonList = prefs.getStringList('nestedList');
  if (nestedJsonList != null) {
    List<List<String>> nestedList = nestedJsonList
        .map((jsonString) => List<String>.from(json.decode(jsonString)))
        .toList();
    return nestedList;
  } else {
    return [];
  }
}

Future<void> addElementToNestedList(List<String> element) async {
  // Retrieve the existing nested list from SharedPreferences
  List<List<String>> nestedList = await getNestedData();

  // Append the new element to the nested list
  nestedList.add(element);

  // Save the updated nested list back to SharedPreferences
  saveNestedData(nestedList);
}
