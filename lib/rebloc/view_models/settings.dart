import 'package:chs_connect/models/chs_settings.dart';
import 'package:chs_connect/rebloc/states/main.dart';
import 'package:chs_connect/rebloc/states/settings.dart';
import 'package:equatable/equatable.dart';

class ChsSettingsViewModel extends Equatable {
  final ChsSettingsModel model;
  final bool isLoading;
  final bool hasError;
  final dynamic error;

  ChsSettingsViewModel(ChsAppState state)
      : model = state.settings.settings,
        isLoading = state.settings.status == ChsSettingsStatus.loading,
        hasError = state.settings.status == ChsSettingsStatus.failure,
        error = state.settings.error,
        super(<ChsAppState>[state]);
}