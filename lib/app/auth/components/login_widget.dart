import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

import 'package:chs_connect/app/auth/components/auth_bkg.dart';
import 'package:chs_connect/app/auth/components/login_card.dart';

class LoginWidget extends StatelessWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  LoginWidget(this.analytics, this.observer);

  Widget buildLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          AuthBackground(),
          LoginCard(analytics: analytics, observer: observer,),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildLayout(context);
  }
}
