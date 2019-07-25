import 'package:chs_connect/models/chs_base_model.dart';
import 'package:chs_connect/services/chs_auth.dart';
import 'package:chs_connect/services/chs_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class ChsPostMediaModel extends ChsBaseModel {
  String id;
  String userID;
  String postID;
  String path;
  String src;
  int mediaType;
  Timestamp createdAt;

  ChsPostMediaModel({
    String id,
    String userID,
    @required this.postID,
    @required this.path,
    @required this.src,
    @required this.mediaType,
    Timestamp createdAt,
  })  : id = id ?? Uuid(),
        userID = userID ?? ChsAuth.getUser.uid,
        createdAt = createdAt ?? Timestamp.now();

  ChsPostMediaModel.fromJson(Map<String, dynamic> json)
      : assert(json != null),
        id = json['id'],
        userID = json['userID'],
        postID = json['postID'],
        path = json['path'],
        src = json['src'],
        mediaType = json['mediaType'],
        createdAt = Timestamp.fromMillisecondsSinceEpoch(json['createdAt']);

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userID': userID,
      'postID': postID,
      'path': path,
      'src': src,
      'mediaType': mediaType,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}
