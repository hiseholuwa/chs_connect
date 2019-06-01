import 'package:chs_connect/models/chs_base_model.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum ChsAccountModelStatus {enabled, disabled, warning, pending}

class ChsAccountModel extends ChsBaseModel{
  String uid;
  String email;
  String userName;
  String photoUrl;
  ChsAccountModelStatus status;


  ChsAccountModel copyWith({
    String userName,
    String photoUrl,
    ChsAccountModelStatus status,

  }) {
    return ChsAccountModel(
      uid : this.uid,
      email : this.email,
      userName : userName ?? this.userName,
      photoUrl : photoUrl ?? this.photoUrl,
      status : status ?? this.status,
    )..reference = this.reference;
  }
  factory ChsAccountModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    return ChsAccountModel(
      uid : json['uid'],
      email : json['email'],
      userName : json['userName'],
      photoUrl : json['photoUrl'],
      status : ChsAccountModelStatus.values[int.tryParse(json['status'].toString())],
    );
  }

  factory ChsAccountModel.fromDoc(DocumentSnapshot doc) => ChsAccountModel.fromJson(doc.data)..reference = doc.reference;

  ChsAccountModel({
    @required this.uid,
    @required this.email,
    @required this.userName,
    @required this.photoUrl,
    @required this.status,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid' : uid,
      'email' : email,
      'userName' : userName,
      'photoUrl' : photoUrl,
      'status' : status.index,
    };
  }
}