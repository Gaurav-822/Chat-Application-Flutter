import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessageApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    return fCMToken;
  }
}
