import 'package:chat_app/Functions/toasts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> addLove(String userUid, String loveUid) async {
  User? user = FirebaseAuth.instance.currentUser;
  String? uuid;
  if (user != null) {
    uuid = user.uid;
  } else {
    return;
  }

  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc("profiles")
        .collection(uuid)
        .doc("relations")
        .set({
      'Love': loveUid,
    }, SetOptions(merge: true));
  } catch (error) {
    showToastMessage("Failed to update friend love: $error");
    throw ("Failed to update friend love: $error");
  }
}

Future<String?> getLove(String userUid) async {
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc("profiles")
        .collection(userUid)
        .doc("relations")
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('Love')) {
        return data['Love'] as String?;
      }
    }
    return null;
  } catch (error) {
    throw ("Failed to get love string: $error");
  }
}
