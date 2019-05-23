import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ChsBaseModel {
  SharedPreferences prefs;
}

abstract class ChsUserAuthModel {
  bool _isLogin = false;
}

class ChsStateModel extends Model
    with
        ChsBaseModel,
        ChsUserAuthModel{
  ChsStateModel(SharedPreferences _prefs) {
    prefs = _prefs;
  }
}







