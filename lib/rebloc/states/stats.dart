import 'package:chs_connect/models/stats.dart';
import 'package:meta/meta.dart';

enum ChsStatsStatus {loading, success, failure}

@immutable
class ChsStatsState {
  const ChsStatsState({
    @required this.stats,
    @required this.status,
    @required this.message,
    this.error,
  });

  const ChsStatsState.initialState()
      : stats = null,
        status = ChsStatsStatus.loading,
        message = '',
        error = null;

  final ChsStatsModel stats;
  final ChsStatsStatus status;
  final String message;
  final dynamic error;

  ChsStatsState copyWith({
    ChsStatsModel stats,
    ChsStatsStatus status,
    String message,
    dynamic error,
  }) {
    return ChsStatsState(
      stats: stats ?? this.stats,
      status: status ?? this.status,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }

  @override
  String toString() => """ Stats: $stats """;
}
