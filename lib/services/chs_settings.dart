import 'package:chs_connect/constants/chs_constants.dart';
import 'package:chs_connect/utils/chs_preferences.dart';
import 'package:get_version/get_version.dart';
import 'package:chs_connect/models/chs_settings.dart';

class ChsSettings {
  ChsSettings._();

  static int userId;
  static String tokenKey;
  static ChsSettingsModel _settings;

  static String _versionName = "";
  static Future<void> initVersion() async => _versionName = await GetVersion.projectVersion.catchError((dynamic e) => null);
  static void setVersion(String version) => _versionName = version;
  static String getVersion() => _versionName;
  static void setData(ChsSettingsModel data) => _settings = data;
  static ChsSettingsModel getData() => _settings;
  static Future<bool> checkIsFirstTime() async {
    final state = await ChsPreferences.getBool(IS_FIRST_TIME);
    if(state != false) {
      await ChsPreferences.setBool(IS_FIRST_TIME, false);
      return true;
    }
    return false;
  }
  static Future<bool> checkIsFirstTimeLogin() async {
    final state = await ChsPreferences.getBool(IS_FIRST_TIME_LOGIN);
    if (state != false) {
      return true;
    }
    return false;
  }
  static Future<void> updateIsFirstTimeLogin() {
    return ChsPreferences.setBool(IS_FIRST_TIME_LOGIN, false);
  }

}