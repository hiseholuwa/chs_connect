import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

export 'package:provider/provider.dart';

class ChsUserCache extends ChangeNotifier {
  ChsUserCache({Key key}) : _storage = LocalStorage("default");

  LocalStorage _storage;
  String _userName;
  String _name;
  String _email;
  String _phone;
  String _photoUrl;
  String _birthday;
  String _bio;

  void changeUsername(String value) {
    _userName = value;
    _storage.setItem("username", _userName);
    notifyListeners();
  }

  void changeName(String value) {
    _name = value;
    _storage.setItem("name", _name);
    notifyListeners();
  }

  void changeEmail(String value) {
    _email = value;
    _storage.setItem("email", _email);
    notifyListeners();
  }

  void changePhone(String value) {
    _phone = value;
    _storage.setItem("phone", _phone);
    notifyListeners();
  }

  void changePhotoUrl(String value) {
    _photoUrl = value;
    _storage.setItem("photourl", _photoUrl);
    notifyListeners();
  }

  void changeBirthday(String value) {
    _birthday = value;
    _storage.setItem("birthday", _birthday);
    notifyListeners();
  }

  void changeBio(String value) {
    _bio = value;
    _storage.setItem("bio", _bio);
    notifyListeners();
  }

  void reset() {
    _storage.clear();
    _userName = "";
    _name = "";
    _email = "";
    _phone = "";
    _photoUrl = "";
    _birthday = "";
    _bio = "";
  }

  Future init() async {
    if (await _storage.ready) {
      _userName = _storage.getItem("username");
      _name = _storage.getItem("name");
      _email = _storage.getItem("email");
      _phone = _storage.getItem("phone");
      _photoUrl = _storage.getItem("photourl");
      _birthday = _storage.getItem("birthday");
      _bio = _storage.getItem("bio");
    }
  }

  String get userName {
    if (_userName == null) {
      return "";
    }
    return _userName;
  }

  String get name {
    if (_name == null) {
      return "";
    }
    return _name;
  }

  String get email {
    if (_email == null) {
      return "";
    }
    return _email;
  }

  String get phone {
    if (_phone == null) {
      return "";
    }
    return _phone;
  }

  String get photoUrl {
    if (_photoUrl == null) {
      return "";
    }
    return _photoUrl;
  }

  String get birthday {
    if (_birthday == null) {
      return "";
    }
    return _birthday;
  }

  String get bio {
    if (_bio == null) {
      return "";
    }
    return _bio;
  }
}
