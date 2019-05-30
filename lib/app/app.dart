import 'package:chs_connect/app/auth/welcome.dart';
import 'package:chs_connect/constants/chs_routes.dart';
import 'package:chs_connect/utils/chs_page_transitions.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/services.dart';

class App extends StatefulWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  App({Key key}){
    key = key;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  State<StatefulWidget> createState() {
    return _AppState(analytics, observer);
  }
}

class _AppState extends State<App> {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  _AppState(this.analytics, this.observer);

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor:  Color(0xffeeeeee),
        brightness: brightness
      ),
      themedWidgetBuilder: (context, theme){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          navigatorObservers: [observer],
          onGenerateRoute: (settings) {
            return ChsNavigateRoute<dynamic>(builder: (_){
              return Welcome(analytics: analytics, observer: observer,);
            },
                settings: settings.copyWith(name: ChsRoutes.welcomePageRoute, isInitialRoute: true,));
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
