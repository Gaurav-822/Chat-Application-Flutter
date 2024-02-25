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
