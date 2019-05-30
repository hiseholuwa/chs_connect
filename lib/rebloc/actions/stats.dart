import 'package:chs_connect/models/stats.dart';
import 'package:meta/meta.dart';
import 'package:rebloc/rebloc.dart';

class ChsInitStatsAction extends Action {
  const ChsInitStatsAction();
}

class ChsOnDataStatAction extends Action {
  final ChsStatsModel payload;
  const ChsOnDataStatAction({
    @required this.payload,
  });

}
