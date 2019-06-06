import 'package:chs_connect/app/auth/components/register_widget.dart';
import 'package:chs_connect/constants/chs_colors.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: ChsColors.default_scaffold,
      body: RegisterWidget(analytics, observer),
    );
  }

  @override
  void initState() {
    super.initState();
    _analyticsSetup();
  }

  Future<void> _analyticsSetup() async {
    await analytics.setCurrentScreen(
        screenName: 'Register Screen', screenClassOverride: 'RegisterScreen');
  }
}
