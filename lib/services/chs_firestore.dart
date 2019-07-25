import 'package:chs_connect/services/chs_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

export 'package:cloud_firestore/cloud_firestore.dart';

final Firestore instance = Firestore.instance;
final FirebaseUser authUser = ChsAuth.getUser;

class ChsFirestore {
  ChsFirestore._();

  static String get authUserId => authUser.uid ?? null;

  static DocumentReference get user => instance.document('user/$authUserId');

  static DocumentReference userName(String name) => instance.document('username/$name');

  static DocumentReference get token => instance.document('token/$authUserId');

  static CollectionReference get posts => instance.collection('posts');

  static Map<String, dynamic> idToMap(String id) {
    return <String, dynamic>{
      'id': id,
    };
  }


}