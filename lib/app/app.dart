import 'package:chs_connect/app/auth/splash.dart';
import 'package:chs_connect/constants/chs_routes.dart';
import 'package:chs_connect/rebloc/actions/common.dart';
import 'package:chs_connect/rebloc/main.dart';
import 'package:chs_connect/rebloc/states/main.dart';
import 'package:chs_connect/services/chs_settings.dart';
import 'package:chs_connect/utils/chs_page_transitions.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter/services.dart';
import 'package:rebloc/rebloc.dart';

class App extends StatefulWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  App({@required this.isFirstTime}){
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    FlutterStatusbarcolor.setStatusBarColor(Colors.black);
  }

  final bool isFirstTime;

  static Future<BootstrapModel> bootstrap() async {
    final isFirstTime = await ChsSettings.checkIsFirstTimeLogin();
    try {
      await ChsSettings.initVersion();
    } catch (e) {
    }

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
  final Store<ChsAppState> store = reblocStore();
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
        return StoreProvider<ChsAppState>(
          store: store,
          child: FirstBuildDispatcher<ChsAppState>(
            action: const ChsOnInitAction(),
            child: Builder(
              builder: (BuildContext context){
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: theme,
                  navigatorObservers: [observer],
                  onGenerateRoute: (settings) {
                    return ChsNavigateRoute<dynamic>(builder: (_){
                      return Splash(analytics: analytics, observer: observer,);
                    },
                        settings: settings.copyWith(name: ChsRoutes.splashPageRoute, isInitialRoute: true,));
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    store.dispatcher(const ChsOnDisposeAction());
    super.dispose();
  }
}

class BootstrapModel {
  const BootstrapModel({
    @required this.isFirstTime,
  });

  final bool isFirstTime;
}
