import 'package:chs_connect/app/auth/components/recovery_widget.dart';
import 'package:chs_connect/constants/chs_colors.dart';
import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

class RecoveryPage extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  const RecoveryPage({Key key, this.analytics, this.observer}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _RecoveryPageState(analytics, observer);
  }
}

class _RecoveryPageState extends State<RecoveryPage> {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  _RecoveryPageState(this.analytics, this.observer);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChsColors.default_scaffold,
      body: RecoveryWidget(analytics, observer),
    );
  }

  @override
  void initState() {
    super.initState();
    _analyticsSetup();
  }

  Future<void> _analyticsSetup() async {
    await analytics.setCurrentScreen(
        screenName: 'Recovery Screen', screenClassOverride: 'RecoveryScreenClass');
  }

}
