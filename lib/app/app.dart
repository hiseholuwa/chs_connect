import 'package:chs_connect/app/auth/splash.dart';
import 'package:chs_connect/constants/chs_routes.dart';
import 'package:chs_connect/services/chs_settings.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:chs_connect/utils/chs_page_transitions.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/services.dart';

class App extends StatefulWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  App({@required this.isFirstTime}) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  final bool isFirstTime;

  static Future<BootstrapModel> bootstrap() async {
    final isFirstTime = await ChsSettings.checkIsFirstTimeLogin();
    try {
      await ChsSettings.initVersion();
    } catch (e) {}

    return BootstrapModel(isFirstTime: isFirstTime);
  }

  @override
  State<StatefulWidget> createState() {
    return _AppState(analytics, observer);
  }
}

class _AppState extends State<App> {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final _model = ChsThemeModel();
  _AppState(this.analytics, this.observer);

  @override
  Widget build(BuildContext context) {
    return ListenableProvider<ChsThemeModel>(
      builder: (_) => _model..init(),
      child: Consumer<ChsThemeModel>(builder: (context, model, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: model.theme,
          navigatorObservers: [observer],
          onGenerateRoute: (settings) {
            return ChsNavigateRoute<dynamic>(
                builder: (_) {
                  return Splash(
                    analytics: analytics,
                    observer: observer,
                  );
                },
                settings: settings.copyWith(
                  name: ChsRoutes.splashPageRoute,
                  isInitialRoute: true,
                ));
          },
        );
      }),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class BootstrapModel {
  const BootstrapModel({
    @required this.isFirstTime,
  });

  final bool isFirstTime;
}
