import 'package:chs_connect/rebloc/blocs/auth.dart';
import 'package:chs_connect/rebloc/blocs/initialize.dart';
import 'package:chs_connect/rebloc/blocs/settings.dart';
import 'package:chs_connect/rebloc/states/main.dart';
import 'package:rebloc/rebloc.dart';

Store<ChsAppState> reblocStore() {
  return Store<ChsAppState>(
    initialState: ChsAppState.initialState(),
    blocs: [
      ChsInitializeBloc(),
      ChsAuthBloc(),
      ChsSettingsBloc(),
    ]
  );
}