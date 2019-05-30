import 'package:chs_connect/app/auth/components/auth_bkg.dart';
import 'package:chs_connect/app/auth/components/register_card.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

class RegisterWidget extends StatelessWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  RegisterWidget(this.analytics, this.observer);
  Widget buildLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          AuthBackground(),
          RegisterCard(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildLayout(context);
  }
}
