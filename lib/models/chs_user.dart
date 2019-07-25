import 'package:chs_connect/models/chs_base_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChsUser extends ChsBaseModel {
  final String username;
  final String name;
  final String email;
  final String phone;
  final String bio;
  final int posts;
  final int followers;
  final int following;
  final bool private;
  final String photoUrl;
  final DateTime birthday;
  final String gradYear;
  final Timestamp createdAt;

  ChsUser({this.username, this.name, this.email, this.phone, this.bio, this.posts, this.followers, this.following, this.private, this.photoUrl, this.birthday, this.gradYear, this.createdAt});

  factory ChsUser.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    return ChsUser(
      username: json['username'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      bio: json['bio'],
      posts: json['posts'],
      followers: json['followers'],
      following: json['following'],
      private: json['private'],
      photoUrl: json['photoUrl'],
      birthday: DateTime.tryParse(json['birthday'].toString()),
      gradYear: json['gradYear'],
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
    int posts,
    int followers,
    int following,
    bool private,
    String photoUrl,
    DateTime birthday,
    String gradYear,
  }) {
    return ChsUser(
      username: username ?? this.username,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      posts: posts ?? this.posts,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      private: private ?? this.private,
      photoUrl: photoUrl ?? this.photoUrl,
      birthday: birthday ?? this.birthday,
      gradYear: gradYear ?? this.gradYear,
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
      'posts': posts,
      'followers': followers,
      'following': following,
      'private': private,
      'photoUrl': photoUrl,
      'birthday': birthday.toString(),
      'gradYear': gradYear,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}
