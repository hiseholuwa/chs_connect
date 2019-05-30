import 'package:chs_connect/rebloc/states/account.dart';
import 'package:chs_connect/rebloc/states/settings.dart';
import 'package:chs_connect/rebloc/states/stats.dart';
import 'package:flutter/foundation.dart';

@immutable
class ChsAppState {
  final ChsAccountState account;
  final ChsSettingsState settings;
  final ChsStatsState stats;

  const ChsAppState({
    @required this.account,
    @required this.settings,
    @required this.stats,
  });

  const ChsAppState.initialState()
      : account = const ChsAccountState.initialState(),
        settings = const ChsSettingsState.initialState(),
        stats = const ChsStatsState.initialState();

  ChsAppState copyWith({
    ChsAccountState account,
    ChsSettingsState settings,
    ChsStatsState stats,
  }) {
    return ChsAppState(
      account: account ?? this.account,
      settings: settings ?? this.settings,
      stats: stats ?? this.stats,
    );
  }

  @override
  String toString() => """ 
  $account
  $settings 
  $stats
  """;
}