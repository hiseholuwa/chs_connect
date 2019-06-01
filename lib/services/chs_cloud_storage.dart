
import 'package:chs_connect/services/chs_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChsCloudStorage {
  ChsCloudStorage._();

  static FirebaseStorage instance = FirebaseStorage.instance;

  static FirebaseUser user = ChsAuth.getUser as FirebaseUser;

  static String get authUserId  => user.uid ?? null;

  static StorageReference get contacts => instance.ref().child('$authUserId/contacts');
  static StorageReference get references => instance.ref().child('$authUserId/references');
}