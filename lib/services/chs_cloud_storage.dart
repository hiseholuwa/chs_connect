
import 'package:chs_connect/services/chs_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChsCloudStorage {
  ChsCloudStorage._();

  static FirebaseStorage instance = FirebaseStorage.instance;

  static String get authUserId => ChsAuth.getUser?.uid ?? null;

  static StorageReference get contacts => instance.ref().child('$authUserId/contacts');
  static StorageReference get references => instance.ref().child('$authUserId/references');
}