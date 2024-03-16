import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> getUserImageUrl(String uuid) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc("profiles")
        .collection(uuid)
        .doc("details")
        .get();

    if (snapshot.exists) {
      return snapshot.data()?['image_url'];
    } else {
      return null; // Document doesn't exist
    }
  } catch (error) {
    print("Error getting name: $error");
    return null;
  }
}

Future<String?> getUserName(String uuid) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc("profiles")
        .collection(uuid)
        .doc("details")
        .get();

    if (snapshot.exists) {
      return snapshot.data()?['name'];
    } else {
      return null; // Document doesn't exist
    }
  } catch (error) {
    print("Error getting name: $error");
    return null;
  }
}
