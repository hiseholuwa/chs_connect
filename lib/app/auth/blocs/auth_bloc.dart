import 'dart:async';

import 'package:chs_connect/app/auth/blocs/auth_validator.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc with AuthValidator {
  final _fullName = BehaviorSubject<String>();
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();

  //extra
  final _username = BehaviorSubject<String>();
  final _phone = BehaviorSubject<String>();
  final _bio = BehaviorSubject<String>();

  //add data to stream
  Stream<String> get fullName => _fullName.stream.transform(validateFullName);
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);

  Stream<bool> get submitValid =>
      Observable.combineLatest3(
          fullName, email, password, (f, e, p) => true);
  Stream<bool> get loginValid =>
      Observable.combineLatest2(email, password, (e, p) => true);

  //extra page
  Stream<String> get username => _username.stream.transform(validateUserName);

  Stream<String> get phone => _phone.stream.transform(validatePhone);

  Stream<String> get bio => _bio.stream.transform(validateBio);

  Stream<bool> get extraContinue =>
      Observable.combineLatest3(
          username, phone, bio, (f, e, p) => true);

  //change data
  Function(String) get changeFullName => _fullName.sink.add;
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;

  //extra
  Function(String) get changeUserName => _username.sink.add;

  Function(String) get changePhone => _phone.sink.add;

  Function(String) get changeBio => _bio.sink.add;

  dispose() {
    _fullName.close();
    _email.close();
    _password.close();
    _username.close();
    _phone.close();
    _bio.close();
  }
}
