import 'package:chs_connect/app/auth/blocs/auth_validator.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

class AuthBloc with AuthValidator {
  final _userName = BehaviorSubject<String>();
  final _fullName = BehaviorSubject<String>();
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();

  //add data to stream
  Stream<String> get userName => _userName.stream.transform(validateUserName);
  Stream<String> get fullName => _fullName.stream.transform(validateFullName);
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream<bool> get submitValid => Observable.combineLatest4(
      userName, fullName, email, password, (u, f, e, p) => true);
  Stream<bool> get loginValid =>
      Observable.combineLatest2(email, password, (e, p) => true);

  //change data
  Function(String) get changeUserName => _userName.sink.add;
  Function(String) get changeFullName => _fullName.sink.add;
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;

  dispose() {
    _userName.close();
    _fullName.close();
    _email.close();
    _password.close();
  }
}
