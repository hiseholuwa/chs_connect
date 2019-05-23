import 'package:chs_connect/app/auth/components/register_widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;
  RegisterPage({Key key, this.analytics, this.observer}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState(analytics, observer);
  }
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  _RegisterPageState(this.analytics, this.observer);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffeeeeee),
      body: RegisterWidget(),
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    _analyticsSetup();
  }

  Future<void> _analyticsSetup() async {
    await analytics.setCurrentScreen(
        screenName: 'Register Screen', screenClassOverride: 'RegisterScreen');
    await analytics.android.setAnalyticsCollectionEnabled(true);
  }
}