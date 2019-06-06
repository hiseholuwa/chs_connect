import 'package:chs_connect/app/auth/components/login_widget.dart';
import 'package:chs_connect/constants/chs_colors.dart';
import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  const LoginPage({Key key, this.analytics, this.observer}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState(analytics, observer);
  }
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  _LoginPageState(this.analytics, this.observer);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChsColors.default_scaffold,
      body: LoginWidget(analytics, observer),
    );
  }

  @override
  void initState() {
    super.initState();
    _analyticsSetup();
  }

  Future<void> _analyticsSetup() async {
    await analytics.setCurrentScreen(
        screenName: 'Login Screen', screenClassOverride: 'LoginScreenClass');
  }

}
