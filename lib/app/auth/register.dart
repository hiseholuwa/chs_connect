import 'package:chs_connect/app/auth/components/register_widget.dart';
import 'package:chs_connect/constants/chs_colors.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  _RegisterPageState();

  @override
  Widget build(BuildContext context) {
    changeStatusBar();
    return Scaffold(
      backgroundColor: ChsColors.default_scaffold,
      body: RegisterWidget(),
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

  void changeStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light));
  }
}
