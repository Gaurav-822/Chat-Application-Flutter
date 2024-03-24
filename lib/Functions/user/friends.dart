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

void updateFriendUpdatedAtOnline(String friendUuid) async {
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
  } catch (error) {
    showToastMessage("Failed to update friend: $error");
    throw ("Failed to update friend: $error");
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
            value['added_at'].toString(),
            value['updated_at'].toString(),
            value['messaged'],
          ]);
        });
      }
    }

    saveNestedData(friendsList);
    // return friendsList;
  } catch (error) {
    saveNestedData([]);
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

void updateFriendUpdatedAtLocal(String friendUuid) async {
  List<List<String>> friendsList = await getNestedData();
  int friendIndex = -1;

  // Find the index of the friend with the provided UUID
  for (int i = 0; i < friendsList.length; i++) {
    if (friendsList[i][1] == friendUuid) {
      friendIndex = i;
      break;
    }
  }

  if (friendIndex != -1) {
    // Update the updated_at field for the friend
    friendsList[friendIndex][3] = DateTime.now().toIso8601String();
    // Save the modified nested list back to shared preferences
    friendsList[friendIndex][4] = "yes";
    saveNestedData(friendsList);
    print('Friend updated successfully');
  } else {
    print('Friend with UUID $friendUuid not found');
  }
}

void updateFriendUpdated(String friendUuid) {
  updateFriendUpdatedAtLocal(friendUuid);
  updateFriendUpdatedAtOnline(friendUuid);
}

Future<void> addElementToNestedList(List<String> element) async {
  // Append timestamps to the element
  String addedAt = DateTime.now().toIso8601String();
  String updatedAt = addedAt;

  // Add timestamps to the element
  element.add(addedAt);
  element.add(updatedAt);
  element.add("no");

  // Retrieve the existing nested list from SharedPreferences
  List<List<String>> nestedList = await getNestedData();

  // Append the new element to the nested list
  nestedList.add(element);

  // Save the updated nested list back to SharedPreferences
  saveNestedData(nestedList);
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
