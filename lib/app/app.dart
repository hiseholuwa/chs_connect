import 'package:chs_connect/app/auth/blocs/auth_provider.dart';
import 'package:chs_connect/app/auth/login.dart';
import 'package:chs_connect/app/auth/register.dart';
import 'package:chs_connect/constants/chs_routes.dart';
import 'package:chs_connect/models/chs_base_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:page_transition/page_transition.dart';

class App extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
  final ChsStateModel model;
  App({Key key, this.model}) :super(key:key);
  @override
  Widget build(BuildContext context) {
    return ScopedModel<ChsStateModel>(
        model: model,
        child: MaterialApp(
          home: AuthProvider(
            child: LoginPage(
              analytics: analytics,
              observer: observer,
            ),
          ),
          navigatorObservers: [observer],
          onGenerateRoute: (settings) {
            switch(settings.name) {
              case ChsRoutes.registerPageRoute:
                return PageTransition(
                  child: AuthProvider(
                    child: RegisterPage(analytics: analytics, observer: observer,),
                  ),
                  type: PageTransitionType.rightToLeft
                );
                break;
            }
          },
        ),
    );
  }
}