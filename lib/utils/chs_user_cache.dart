import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

export 'package:provider/provider.dart';

class ChsUserCache extends ChangeNotifier {
  ChsUserCache({Key key}) : _storage = LocalStorage("default");

  LocalStorage _storage;
  String _username;
  String _name;
  String _email;
  String _phone;
  String _photoUrl;
  String _birthday;
  String _gradYear;
  String _bio;
  int _posts;
  int _followers;
  int _following;
  bool _private;

  void changeUsername(String value) {
    _username = value;
    _storage.setItem("username", _username);
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

  void changeGradYear(String value) {
    _gradYear = value;
    _storage.setItem("gradYear", _gradYear);
    notifyListeners();
  }

  void changeBio(String value) {
    _bio = value;
    _storage.setItem("bio", _bio);
    notifyListeners();
  }

  void changePosts(int value) {
    _posts = value;
    _storage.setItem("posts", _posts);
    notifyListeners();
  }

  void changeFollowers(int value) {
    _followers = value;
    _storage.setItem("followers", _followers);
    notifyListeners();
  }

  void changeFollowing(int value) {
    _following = value;
    _storage.setItem("following", _following);
    notifyListeners();
  }

  void changePrivate(bool value) {
    _private = value;
    _storage.setItem("private", _private);
    notifyListeners();
  }

  void reset() {
    _storage.clear();
    _username = "";
    _name = "";
    _email = "";
    _phone = "";
    _photoUrl = "";
    _birthday = "";
    _gradYear = "";
    _bio = "";
    _posts = 0;
    _followers = 0;
    _following = 0;
    _private = false;
  }

  Future init() async {
    if (await _storage.ready) {
      _username = _storage.getItem("username");
      _name = _storage.getItem("name");
      _email = _storage.getItem("email");
      _phone = _storage.getItem("phone");
      _photoUrl = _storage.getItem("photourl");
      _birthday = _storage.getItem("birthday");
      _gradYear = _storage.getItem("gradYear");
      _bio = _storage.getItem("bio");
      _posts = _storage.getItem("posts");
      _followers = _storage.getItem("followers");
      _following = _storage.getItem("following");
      _private = _storage.getItem("private");
    }
  }

  String get username {
    if (_username == null) {
      return "";
    }
    return _username;
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

  String get gradYear {
    if (_gradYear == null) {
      return "";
    }
    return _gradYear;
  }

  String get bio {
    if (_bio == null) {
      return "";
    }
    return _bio;
  }

  int get posts {
    if (_posts == null) {
      return 0;
    }
    return _posts;
  }

  int get followers {
    if (_followers == null) {
      return 0;
    }
    return _followers;
  }

  int get following {
    if (_following == null) {
      return 0;
    }
    return _following;
  }

  bool get private {
    if (_private == null) {
      return false;
    }
    return _private;
  }
}
