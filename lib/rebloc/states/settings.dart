import 'package:chs_connect/models/chs_settings.dart';
import 'package:flutter/foundation.dart';

enum ChsSettingsStatus {loading, success, failure,}

@immutable
class ChsSettingsState {
  final ChsSettingsModel settings;
  final ChsSettingsStatus status;
  final String message;
  final dynamic error;

  const ChsSettingsState({
    @required this.settings,
    @required this.status,
    @required this.message,
    this.error,
  });

  const ChsSettingsState.initialState()
      : settings = null,
        status = ChsSettingsStatus.loading,
        message = "",
        error = null;

  ChsSettingsState copyWith({
    ChsSettingsModel settings,
    ChsSettingsStatus status,
    String message,
    dynamic error,
  }) {
    return ChsSettingsState(
      settings: settings ?? this.settings,
      status: status ?? this.status,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }

  @override
  String toString() => """ Settings: $settings """;
}