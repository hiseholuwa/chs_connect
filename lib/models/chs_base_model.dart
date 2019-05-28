import 'package:shared_preferences/shared_preferences.dart';

abstract class ChsBaseModel {
  SharedPreferences prefs;
}

abstract class ChsUserAuthModel {
  bool _isLogin = false;
}








