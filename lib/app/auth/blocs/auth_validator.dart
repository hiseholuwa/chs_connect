import 'package:chs_connect/constants/chs_strings.dart';
import 'dart:async';

class AuthValidator {
  static final _emailRegExpString =
      r'[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\@[a-zA-Z0-9]'
      r'[a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25})+';

  final validateEmail =
  StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    bool isValid =
    RegExp(_emailRegExpString, caseSensitive: false).hasMatch(email);
    if (isValid) {
      sink.add(email);
    } else {
      sink.addError(ChsStrings.enter_valid_email);
    }
  });

  final validateUserName = StreamTransformer<String, String>.fromHandlers(
      handleData: (userName, sink) {
        if (userName.length >= 2) {
          sink.add(userName);
        } else {
          sink.addError(ChsStrings.enter_valid_username);
        }
      });

  final validateFullName = StreamTransformer<String, String>.fromHandlers(
      handleData: (fullName, sink) {
        if (fullName.length >= 2) {
          sink.add(fullName);
        } else {
          sink.addError(ChsStrings.enter_valid_full_name);
        }
      });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
        if (password.length >= 6) {
          sink.add(password);
        } else {
          sink.addError(ChsStrings.enter_valid_password);
        }
      });
}
