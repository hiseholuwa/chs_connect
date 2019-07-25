import 'package:chs_connect/models/chs_base_model.dart';
import 'package:chs_connect/models/chs_post_media.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChsPost extends ChsBaseModel {
  final String authorUsername;
  final String authorPhotoUrl;
  final String authorId;
  final String postDesc;
  final List<String> tags;
  final List<ChsPostMediaModel> media;
  final int postType;
  final int likes;
  final int comments;
  final Timestamp createdAt;
  final Timestamp editedAt;
  final bool disableComments;
  final bool disableSharing;

  ChsPost(
      {this.authorUsername,
      this.authorPhotoUrl,
      this.authorId,
      this.postDesc,
      this.tags,
      this.media,
      this.postType,
      this.likes,
      this.comments,
      this.createdAt,
      this.editedAt,
      this.disableComments,
      this.disableSharing});

  factory ChsPost.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    return ChsPost(
      authorUsername: json['authorUsername'],
      authorPhotoUrl: json['authorPhotoUrl'],
      authorId: json['authorId'],
      postDesc: json['postDesc'],
      tags: json['tags'],
      media: ChsBaseModel.generator(
        json['media'],
        (dynamic media) => ChsPostMediaModel.fromJson(media.cast<String, dynamic>()),
      ),
      postType: json['postType'],
      likes: json['likes'],
      comments: json['comments'],
      createdAt: Timestamp.fromMillisecondsSinceEpoch(json['createdAt']),
      editedAt: Timestamp.fromMillisecondsSinceEpoch(json['editedAt']),
      disableComments: json['disableComments'],
      disableSharing: json['disableSharing'],
    );
  }

  factory ChsPost.fromDoc(DocumentSnapshot doc) => ChsPost.fromJson(doc.data)..reference = doc.reference;

  ChsPost copyWith({
    String authorUsername,
    String authorPhotoUrl,
    String authorId,
    String postDesc,
    List<String> tags,
    List<ChsPostMediaModel> media,
    int postType,
    int likes,
    int comments,
    Timestamp createdAt,
    Timestamp editedAt,
    bool disableComments,
    bool disableSharing,
  }) {
    return ChsPost(
      authorUsername: authorUsername ?? this.authorUsername,
      authorPhotoUrl: authorPhotoUrl ?? this.authorPhotoUrl,
      authorId: authorId ?? this.authorId,
      postDesc: postDesc ?? this.postDesc,
      tags: tags ?? this.tags,
      media: media ?? this.media,
      postType: postType ?? this.postType,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
      editedAt: editedAt ?? this.editedAt,
      disableComments: disableComments ?? this.disableComments,
      disableSharing: disableSharing ?? this.disableSharing,
    )..reference = this.reference;
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'authorUsername': authorUsername,
      'authorPhotoUrl': authorPhotoUrl,
      'authorId': authorId,
      'postDesc': postDesc,
      'tags': tags,
      'media': media.map((media) => media.toMap()).toList(),
      'postType': postType,
      'likes': likes,
      'comments': comments,
      'createdAt': createdAt,
      'editedAt': editedAt,
      'disableComments': disableComments,
    };
  }
}
