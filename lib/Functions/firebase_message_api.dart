import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FirebaseMessageApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    return fCMToken;
  }
}

Future<String?> getFCMTokenByUsername(String username) async {
  FirebaseMessageApi firebaseMessageApi = FirebaseMessageApi();

  String? fCMToken = await firebaseMessageApi.initNotification();

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc("profile")
        .collection("admin")
        .where('name', isEqualTo: username)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        return doc.get('fcmToken'); // Return the FCM token
      }
    } else {
      return null; // No user found with the given username
    }
  } catch (error) {
    print("Error fetching document: $error");
    return null; // Return null if there's an error
  }
}

Future<void> sendNotification(
    String title, String text, String fcmToken) async {
  // Replace with your actual server key
  final String serverKey =
      'AAAAdKq6UDE:APA91bFlbO7B5pk8UV1IqZDncvTLVd8PvuYRRQCfd_HwA96puUbPDYCqZp7M4Tly90JnnwGpDKyGkn14hSyG0smXJNXD94WMIwX3ZwC1A16FL6hSxXG_GxrJYT1Y566NNVloIsihTmNN';
  final String url = 'https://fcm.googleapis.com/fcm/send';

  final Map<String, dynamic> notification = {
    'body': text,
    'title': title, // Optional title
    // Add any other fields you want to include in the notification
  };

  final Map<String, dynamic> messageBody = {
    'notification': notification,
    'to': fcmToken,
    'data': {'message': text}, // Add extra data if needed
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(messageBody),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification. Error: ${response.body}');
    }
  } catch (e) {
    print('Failed to send notification. Exception: $e');
  }
}

Future<bool> sendNotificationToUser(
    String username, String title, String text) async {
  // Fetch the FCM token
  String? fcmToken;
  try {
    fcmToken = await getFCMTokenByUsername(username);
  } catch (error) {
    print("Error fetching FCM token: $error");
    return false;
  }

  if (fcmToken == null) {
    print("No FCM token found for user: $username");
    return false;
  }

  // Send the notification
  try {
    await sendNotification(title, text, fcmToken);
    return true;
  } catch (error) {
    print("Error sending notification: $error");
    return false;
  }
}
