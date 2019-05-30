import 'package:chs_connect/constants/chs_strings.dart';
import 'package:chs_connect/models/chs_settings.dart';
import 'package:chs_connect/rebloc/actions/common.dart';
import 'package:chs_connect/rebloc/actions/settings.dart';
import 'package:chs_connect/rebloc/states/main.dart';
import 'package:chs_connect/rebloc/states/settings.dart';
import 'package:chs_connect/services/chs_firestore.dart';
import 'package:chs_connect/services/chs_settings.dart';
import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';

class ChsSettingsBloc extends SimpleBloc<ChsAppState> {
  Stream<WareContext<ChsAppState>> applyMiddleWare(Stream<WareContext<ChsAppState>> input) {
    Observable(input)
        .where((_) => _.action is ChsInitSettingsAction)
        .switchMap(
        (context) => ChsFirestore.settings
            .snapshots()
            .map((snapshot){
              if (snapshot.data == null) {
                throw FormatException(ChsStrings.connection_error);
              }
              return ChsSettingsModel.fromJson(snapshot.data);
        })
        .handleError(() => context.dispatcher(const ChsOnErrorSettingsAction())
        )
        .map((settings) {
          ChsSettings.setData(settings);
          return ChsOnDataSettingsAction(payload: settings);
        })
        .map((action) => context.copyWith(action))
        .takeWhile((_) => _.action is! ChsOnDisposeAction),
    )
    .listen((context) => context.dispatcher(context.action));
    return input;
  }

  @override
  ChsAppState reducer(ChsAppState state, Action action) {
    final _settings = state.settings;
    if(action is ChsOnDataSettingsAction) {
      return state.copyWith(
        settings: _settings.copyWith(
          settings: action.payload,
          status:  ChsSettingsStatus.success,
        )
      );
    }
    if(action is ChsOnErrorSettingsAction) {
      return state.copyWith(
        settings: _settings.copyWith(
          status: ChsSettingsStatus.failure,
        )
      );
    }
    return state;
  }
}