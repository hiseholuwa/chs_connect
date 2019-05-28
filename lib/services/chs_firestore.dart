import 'package:chs_connect/services/chs_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChsFirestore {
  ChsFirestore._();

  static Firestore instance = Firestore.instance;

  static String get authUserId => ChsAuth.getUser?.uid ?? null;


}