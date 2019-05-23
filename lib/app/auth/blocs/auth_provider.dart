import 'package:chs_connect/app/auth/blocs/auth_bloc.dart';
export 'package:chs_connect/app/auth/blocs/auth_bloc.dart';
import 'package:flutter/material.dart';

class AuthProvider extends InheritedWidget {
  final AuthBloc bloc;

  AuthProvider({Key key, Widget child})
      : bloc = AuthBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static AuthBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(AuthProvider) as AuthProvider)
        .bloc;
  }
}
