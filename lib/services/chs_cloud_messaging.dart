import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

export 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _messaging = FirebaseMessaging();

class ChsFCM {
  ChsFCM._();

  static String _token;

  static Future<void> getFCMToken() async {
    _token = await _messaging.getToken();
  }

  static Map<String, dynamic> tokenToMap() {
    return <String, dynamic>{
      'token': _token,
    };
  }

  static String getFCMTokenFromDoc(DocumentSnapshot doc) {
    String token = doc['token'];
    return token;
  }
}
