import 'dart:convert';

import 'package:chat_app/Functions/toasts.dart';
import 'package:chat_app/Functions/user/get_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// adds a user to friends list
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
      'friends.$friendUuid': {
        'name': name,
        'uuid': friendUuid,
        'added_at':
            FieldValue.serverTimestamp(), // Timestamp when friend is added
        'updated_at': FieldValue
            .serverTimestamp(), // Timestamp when friend is last updated
        'messaged': "no",
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
          'added_at':
              FieldValue.serverTimestamp(), // Timestamp when friend is added
          'updated_at': FieldValue
              .serverTimestamp(), // Timestamp when friend is last updated
          'messaged': "no",
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

// removes a user from the friends list
void removeFriend(String friendUuid) async {
  // Check the user has the previlages to remove friends or not ?
  User? user = FirebaseAuth.instance.currentUser;
  String? uuid;
  if (user != null) {
    uuid = user.uid;
  } else {
    showToastMessage("No user is currently authenticated.");
    return;
  }
  // Remove from firestore
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc("profiles")
        .collection(uuid)
        .doc("relations")
        .update({
      'friends.$friendUuid': FieldValue.delete(),
    }).then((_) {
      showToastMessage("Friend removed successfully");
    });
  } catch (error) {
    showToastMessage("Failed to remove friend: $error");
    throw ("Failed to remove friend: $error");
  }
  // Remove locally
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? friendsList = prefs.getStringList('friends_list');

  if (friendsList != null && friendsList.isNotEmpty) {
    List<String> updatedList = [];
    for (String friendData in friendsList) {
      List<String> friendInfo = friendData.split(',');
      if (friendInfo.length >= 2 && friendInfo[1] == friendUuid) {
        continue; // Skip the friend with the specified UUID
      }
      updatedList.add(friendData);
    }
    await prefs.setStringList('friends_list', updatedList);
    showToastMessage("Friend removed locally successfully");
  } else {
    showToastMessage("No friends to remove locally.");
  }
}

// remove user from chats page
void updateMessagedToNo(String friendUuid) async {
  User? user = FirebaseAuth.instance.currentUser;
  String? uuid;
  if (user != null) {
    uuid = user.uid;
  } else {
    showToastMessage("No user is currently authenticated.");
    return;
  }
  // Update in Firestore
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc("profiles")
        .collection(uuid)
        .doc("relations")
        .update({
      'friends.$friendUuid.messaged': "no",
    }).then((_) {
      showToastMessage("Messaged status updated successfully in Firestore");
    });
  } catch (error) {
    showToastMessage("Failed to update messaged status in Firestore: $error");
    throw ("Failed to update messaged status in Firestore: $error");
  }
  // set the data locally
  setFriendsLocally();
}

// Implement this in the entire app

//updates the timestamp of change for user sets local data accordingly, required for ordering
void updateFriends(String friendUuid) async {
  User? user = FirebaseAuth.instance.currentUser;
  String? uuid;
  if (user != null) {
    uuid = user.uid;
  } else {
    showToastMessage("No user is currently authenticated.");
    return;
  }

  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc("profiles")
        .collection(uuid)
        .doc("relations")
        .update({
      'friends.$friendUuid.updated_at': FieldValue.serverTimestamp(),
      'friends.$friendUuid.messaged': "yes",
    }).then((_) {});
    setFriendsLocally();
  } catch (error) {
    showToastMessage("Failed to update friend: $error");
    throw ("Failed to update friend: $error");
  }
}

// set the friends locally
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
            value['added_at'].toString(),
            value['updated_at'].toString(),
            value['messaged'],
          ]);
        });
      }
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> nestedJsonList =
        friendsList.map((list) => json.encode(list)).toList();
    await prefs.setStringList('nestedList', nestedJsonList);
  } catch (error) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> nestedJsonList = [].map((list) => json.encode(list)).toList();
    await prefs.setStringList('nestedList', nestedJsonList);
    showToastMessage("Failed to fetch friends: $error");
    throw ("Failed to fetch friends: $error");
  }
}

// get the local friends data
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

Future<List<List<String>>> getNestedDataForChat() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? nestedJsonList = prefs.getStringList('nestedList');
  if (nestedJsonList != null) {
    List<List<String>> nestedList = nestedJsonList
        .map((jsonString) => List<String>.from(json.decode(jsonString)))
        .where((innerList) => innerList.isNotEmpty && innerList.last == "yes")
        .toList();
    return nestedList;
  } else {
    return [];
  }
}

List<List<String>> sortNestedList(List<List<String>> dataList) {
  // Convert timestamp strings to DateTime objects
  List<List<dynamic>> convertedList = dataList.map((value) {
    DateTime updatedDateTime = DateTime.tryParse(value[3]) ?? DateTime.now();
    return [
      value[0],
      value[1],
      value[2],
      updatedDateTime.toString(),
      value[4]
    ]; // Convert DateTime to String
  }).toList();

  // Sort the list based on updated_at field
  convertedList.sort((a, b) => a[3].compareTo(b[3]));

  // Convert back to List<List<String>>
  return convertedList.map((list) => list.cast<String>()).toList();
}
