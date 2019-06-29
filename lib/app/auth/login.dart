import 'dart:async';

import 'package:chs_connect/app/auth/components/login_widget.dart';
import 'package:chs_connect/constants/chs_colors.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  _LoginPageState();

  @override
  Widget build(BuildContext context) {
    changeStatusBar();
    return WillPopScope(
      onWillPop: () {
        _revertStatusBarColor();
      },
      child: Scaffold(
        backgroundColor: ChsColors.default_scaffold,
        body: LoginWidget(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _analyticsSetup();
  }


  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _analyticsSetup() async {
    await analytics.setCurrentScreen(
        screenName: 'Login Screen', screenClassOverride: 'LoginScreenClass');
  }

  void changeStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light));
  }

  void _revertStatusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    Navigator.pop(context);
  }


}
