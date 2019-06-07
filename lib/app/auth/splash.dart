import 'package:chs_connect/app/auth/welcome.dart';
import 'package:chs_connect/app/main/main.dart';
import 'package:chs_connect/constants/chs_images.dart';
import 'package:chs_connect/rebloc/actions/common.dart';
import 'package:chs_connect/rebloc/states/main.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:chs_connect/utils/chs_page_transitions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rebloc/rebloc.dart';

class Splash extends StatelessWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  static ChsThemeModel theme;

  Splash({Key key, @required this.analytics, @required this.observer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    theme = Provider.of<ChsThemeModel>(context);
    changeStatusBar(theme);
    Future.delayed(Duration(milliseconds: 500), () {
      authState(context);
    });
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: height * 0.18,
          child: Opacity(
            child: Image.asset(ChsImages.auth_logo),
            opacity: 0,
          ),
        ),
      ),
    );
  }

  Future<void> authState(context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return SpinKitWave(
            color: Colors.white,
            type: SpinKitWaveType.start,
          );
        });
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    if (user != null) {
      Future.delayed(Duration(milliseconds: 1000)).then((_) {
//        Navigator.of(context, rootNavigator: true).pop();
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          StoreProvider.of<ChsAppState>(context)
              .dispatcher(ChsOnLoginAction(user));
          RoutePredicate predicate = (Route<dynamic> route) => false;
          Navigator.pushAndRemoveUntil<void>(
              context,
              ChsPageRoute.fadeIn<void>(MainPage(
                analytics: analytics,
                observer: observer,
              )),
              predicate);
        });
      });
    } else {
      Future.delayed(Duration(milliseconds: 1000)).then((_) {
//        Navigator.of(context, rootNavigator: true).pop();
        RoutePredicate predicate = (Route<dynamic> route) => false;
        Navigator.pushAndRemoveUntil<void>(
            context,
            ChsPageRoute.fadeIn<void>(Welcome(
              analytics: analytics,
              observer: observer,
            )),
            predicate);
      });
    }
  }

  void changeStatusBar(ChsThemeModel theme) {
    if (!theme.darkMode) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light));
    }
  }
}
