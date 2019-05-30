import 'package:chs_connect/models/stats.dart';
import 'package:chs_connect/rebloc/states/main.dart';
import 'package:chs_connect/rebloc/states/stats.dart';
import 'package:equatable/equatable.dart';

class ChsStatsViewModel extends Equatable {
  ChsStatsViewModel(ChsAppState state)
      : model = state.stats.stats,
        isLoading = state.stats.status == ChsStatsStatus.loading,
        hasError = state.stats.status == ChsStatsStatus.failure,
        error = state.stats.error,
        super(<ChsAppState>[state]);

  final ChsStatsModel model;
  final bool isLoading;
  final bool hasError;
  final dynamic error;
}
