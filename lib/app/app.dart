import 'package:chs_connect/app/auth/blocs/auth_provider.dart';
import 'package:chs_connect/app/auth/splash.dart';
import 'package:chs_connect/constants/chs_routes.dart';
import 'package:chs_connect/services/chs_cloud_messaging.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:chs_connect/utils/chs_page_transitions.dart';
import 'package:chs_connect/utils/chs_user_cache.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  App({Key key}) {
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
  static ChsThemeModel theme = ChsThemeModel();
  final _cache = ChsUserCache();

  _AppState(this.analytics, this.observer);

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      builder: (_) => _cache..init(),
      child: Consumer<ChsUserCache>(builder: (context, user, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorObservers: [observer],
          theme: ThemeData(brightness: Brightness.dark),
          darkTheme: ThemeData(brightness: Brightness.light),
          onGenerateRoute: (settings) {
            return ChsNavigateRoute<dynamic>(
                builder: (_) {
                  return AuthProvider(
                    child: Splash(),
                  );
                },
                settings: settings.copyWith(
                  name: ChsRoutes.splashPageRoute,
                  isInitialRoute: true,
                ));
          },
        );
      },),
    );
  }

  @override
  void initState() {
    super.initState();
    ChsFCM.getFCMToken();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

