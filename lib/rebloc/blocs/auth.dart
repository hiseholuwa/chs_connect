import 'package:chs_connect/rebloc/actions/account.dart';
import 'package:chs_connect/rebloc/actions/common.dart';
import 'package:chs_connect/rebloc/actions/settings.dart';
import 'package:chs_connect/rebloc/actions/stats.dart';
import 'package:chs_connect/rebloc/states/main.dart';
import 'package:rebloc/rebloc.dart';

class ChsAuthBloc extends SimpleBloc<ChsAppState> {
  @override
  Future<Action> middleware(
      DispatchFunction dispatcher,
      ChsAppState state,
      Action action,
      ) async {
    if (action is ChsOnLoginAction) {
      dispatcher(const ChsInitAccountAction());
      dispatcher(const ChsInitStatsAction());
    }
    return action;
  }

  @override
  ChsAppState reducer(ChsAppState state, Action action) {
    if (action is ChsOnLogOutAction) {
      return ChsAppState.initialState();
    }

    return state;
  }

  Future<Action> afterWare(
      DispatchFunction dispatcher,
      ChsAppState state,
      Action action,
      ) async {
    if (action is ChsOnLogOutAction) {
      dispatcher(const ChsInitSettingsAction());
    }
    return action;
  }
}