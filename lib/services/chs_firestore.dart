import 'package:chs_connect/services/chs_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChsFirestore {
  ChsFirestore._();

  static Firestore instance = Firestore.instance;
  static FirebaseUser user = ChsAuth.getUser as FirebaseUser;

  static String get authUserId => user.uid ?? null;
  static DocumentReference get stats => instance.document('stats/$authUserId');
  static DocumentReference get settings => instance.document('settings/common');

}