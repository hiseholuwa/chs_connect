import 'package:chs_connect/resources/posts/posts_db_provider.dart';

class ChsRepository {
  List<ChsPostsSource> sources = <ChsPostsSource>[
    postsDbProvider,
  ];

  List<ChsPostsCache> caches = <ChsPostsCache>[
    postsDbProvider,
  ];
}

abstract class ChsPostsSource {}

abstract class ChsPostsCache {
  Future<int> clear();
}
