import 'package:chat_app/Functions/toasts.dart';
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

Future<String?> getFCMToken(String uuid) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc("profiles")
        .collection(uuid)
        .doc("details")
        .get();

    if (snapshot.exists) {
      return snapshot.data()?['fcmToken'];
    } else {
      return null; // Document doesn't exist
    }
  } catch (error) {
    // print("Error getting name: $error");
    return null;
  }
}

Future<void> sendNotification(
    String title, String text, String fcmToken) async {
  const String serverKey = String.fromEnvironment('SERVER_KEY');

  const String url = 'https://fcm.googleapis.com/fcm/send';

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
      // print('Notification sent successfully');
    } else {
      // print('Failed to send notification. Error: ${response.body}');
    }
  } catch (e) {
    // print('Failed to send notification. Exception: $e');
  }
}

Future<bool> sendNotificationToUser(
    String uuid, String title, String text) async {
  // Fetch the FCM token
  String? fcmToken;
  try {
    fcmToken = await getFCMToken(uuid);
  } catch (error) {
    // print("Error fetching FCM token: $error");
    return false;
  }

  if (fcmToken == null) {
    // print("No FCM token found for user: $uuid");
    return false;
  }

  // Send the notification
  try {
    await sendNotification(title, text, fcmToken);
    return true;
  } catch (error) {
    // print("Error sending notification: $error");
    return false;
  }
}
