
import 'package:chs_connect/services/chs_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

export 'package:firebase_storage/firebase_storage.dart';

class ChsCloudStorage {
  ChsCloudStorage._();

  static FirebaseStorage instance = FirebaseStorage.instance;

  static FirebaseUser user = ChsAuth.getUser;

  static String get authUserId  => user.uid ?? null;

  static StorageReference get contacts => instance.ref().child('$authUserId/contacts');
  static StorageReference get references => instance.ref().child('$authUserId/references');

  static StorageReference images(String id) => instance.ref().child('images/$authUserId/$id.jpg');
}