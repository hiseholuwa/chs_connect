import 'package:chs_connect/models/chs_base_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChsUser extends ChsBaseModel {
  final String username;
  final String name;
  final String email;
  final String phone;
  final String bio;
  final String photoUrl;
  final DateTime birthday;
  final Timestamp createdAt;

  ChsUser({this.username, this.name, this.email, this.phone, this.bio, this.photoUrl, this.birthday, this.createdAt});

  factory ChsUser.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    return ChsUser(
      username: json['username'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      bio: json['bio'],
      photoUrl: json['photoUrl'],
      birthday: DateTime.tryParse(json['birthday'].toString()),
      createdAt: Timestamp.fromMillisecondsSinceEpoch(json['createdAt']),
    );
  }

  factory ChsUser.fromDoc(DocumentSnapshot doc) => ChsUser.fromJson(doc.data)..reference = doc.reference;

  ChsUser copyWith({
    String username,
    String name,
    String email,
    String phone,
    String bio,
    String photoUrl,
    DateTime birthday,
  }) {
    return ChsUser(
      username: username ?? this.username,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      photoUrl: photoUrl ?? this.photoUrl,
      birthday: birthday ?? this.birthday,
    )..reference = this.reference;
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'name': name,
      'email': email,
      'phone': phone,
      'bio': bio,
      'photoUrl': photoUrl,
      'birthday': birthday.toString(),
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}
