import 'package:chs_connect/models/chs_account.dart';
import 'package:flutter/foundation.dart';

enum ChsAccountStatus {loading, success, failure}

@immutable
class ChsAccountState {
  final ChsAccountModel account;
  final ChsAccountStatus status;
  final String message;
  final dynamic error;

  const ChsAccountState({
    @required this.account,
    @required this.status,
    @required this.message,
    this.error,
  });

  const ChsAccountState.initialState()
      : account = null,
        status = ChsAccountStatus.loading,
        message = "",
        error = null;

  ChsAccountState copyWith({
    ChsAccountModel account,
    ChsAccountStatus status,
    String message,
    dynamic error,
  }) {
    return ChsAccountState(
      account: account ?? this.account,
      status: status ?? this.status,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }

  @override
  String toString() => """ Account: ${account.toMap()} """;
}