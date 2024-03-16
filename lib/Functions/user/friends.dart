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

Future<void> setFriendsLocally() async {
  User? user = FirebaseAuth.instance.currentUser;
  List<String> friendList = [];

  if (user != null) {
    String uuid = user.uid;

    DocumentSnapshot<Map<String, dynamic>> relationsSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc("profiles")
            .collection(uuid)
            .doc("relations")
            .get();

    if (relationsSnapshot.exists) {
      // If the "relations" document exists, fetch the friends
      Map<String, dynamic>? friendsData = relationsSnapshot.data()?['friends'];
      if (friendsData != null) {
        friendList = friendsData.keys.toList();
      }
    }

    // Update local preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('friends', friendList);
  } else {
    // Handle the case where there's no authenticated user
    print("No user is currently authenticated.");
  }
}
