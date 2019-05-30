import 'package:chs_connect/models/chs_account.dart';
import 'package:chs_connect/models/chs_settings.dart';
import 'package:chs_connect/models/stats.dart';
import 'package:chs_connect/rebloc/states/account.dart';
import 'package:chs_connect/rebloc/states/main.dart';
import 'package:chs_connect/rebloc/states/stats.dart';
import 'package:chs_connect/services/chs_settings.dart';
import 'package:equatable/equatable.dart';
import 'package:version/version.dart';

class ChsMainViewModel extends Equatable {
  final ChsAccountModel account;
  final ChsStatsModel stats;
  final ChsSettingsModel settings;
  final bool isLoading;

  ChsMainViewModel(ChsAppState state)
      : account = state.account.account,
        stats = state.stats.stats,
        settings = state.settings.settings,
        isLoading = state.stats.status == ChsStatsStatus.loading ||
            state.account.status == ChsAccountStatus.loading,
      super(<ChsAppState>[state]);

  bool get chsIsOutDated {
    final currentVersion = Version.parse(ChsSettings.getVersion());
    final latestVersion = Version.parse(settings?.versionName ?? "1.0.0");
    return latestVersion > currentVersion;
  }
  bool get isDisabled =>
      account != null && account.status == ChsAccountModelStatus.disabled;
  bool get isWarning =>
      account != null && account.status == ChsAccountModelStatus.warning;
  bool get isPending =>
      account != null && account.status == ChsAccountModelStatus.pending;
}