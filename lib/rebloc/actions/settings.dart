import 'package:chs_connect/models/chs_settings.dart';
import 'package:rebloc/rebloc.dart';
import 'package:meta/meta.dart';

class ChsInitSettingsAction extends Action {
  const ChsInitSettingsAction();
}

class ChsOnErrorSettingsAction extends Action {
  const ChsOnErrorSettingsAction();
}

class ChsOnDataSettingsAction extends Action {
  final ChsSettingsModel payload;
  const ChsOnDataSettingsAction({@required this.payload});
}