import 'package:firebase_messaging/firebase_messaging.dart';

class CloudMessaging {
  static final _firebaseMessaging = FirebaseMessaging.instance;

  static Future requestPermission() async {
    await _firebaseMessaging.requestPermission();
  }
}
