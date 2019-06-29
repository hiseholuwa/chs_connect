import 'dart:async';

import 'package:chs_connect/app/auth/components/recovery_widget.dart';
import 'package:chs_connect/constants/chs_colors.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecoveryPage extends StatefulWidget {
  const RecoveryPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RecoveryPageState();
  }
}

class _RecoveryPageState extends State<RecoveryPage> {
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  _RecoveryPageState();

  @override
  Widget build(BuildContext context) {
    changeStatusBar();
    return Scaffold(
      backgroundColor: ChsColors.default_scaffold,
      body: RecoveryWidget(),
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

  void changeStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light));
  }
}
