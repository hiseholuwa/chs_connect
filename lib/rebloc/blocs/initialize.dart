import 'package:chs_connect/rebloc/actions/common.dart';
import 'package:chs_connect/rebloc/actions/settings.dart';
import 'package:chs_connect/rebloc/states/main.dart';
import 'package:rebloc/rebloc.dart';

class ChsInitializeBloc extends SimpleBloc<ChsAppState> {
  Future<Action> middleWare(ChsAppState state, Action action, DispatchFunction dispatcher,) async {
    if(action is ChsOnInitAction) {
      dispatcher(const ChsInitSettingsAction());
    }
    return action;
  }
  Future<Action> afterWare(ChsAppState state, Action action, DispatchFunction dispatcher) async {
    if(action is ChsOnDisposeAction){}
    return action;
  }
}