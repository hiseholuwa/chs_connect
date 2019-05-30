import 'package:chs_connect/models/chs_base_model.dart';

class ChsIntStatsModel extends ChsBaseModel {
  final int posts;
  final int followers;
  final int following;

  ChsIntStatsModel({
    this.posts,
    this.followers,
    this.following,
  });

  ChsIntStatsModel.fromJson(Map<String, dynamic> json)
      : assert(json != null),
        posts = int.tryParse(json['posts'].toString()),
        followers = int.tryParse(json['followers'].toString()),
        following = int.tryParse(json['following'].toString());

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'posts': posts,
      'followers': followers,
      'following': following,
    };
  }
}

class ChsStatsModel extends ChsBaseModel {
  ChsStatsModel({
    this.posts,
  });

  ChsStatsModel.fromJson(Map<String, dynamic> json)
      : assert(json != null),
        posts = ChsIntStatsModel.fromJson(json['jobs'].cast<String, dynamic>());


  final ChsIntStatsModel posts;

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'posts': posts.toMap(),
    };
  }
}
