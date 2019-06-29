import 'package:chs_connect/app/auth/verify.dart';
import 'package:chs_connect/app/auth/welcome.dart';
import 'package:chs_connect/app/main/main.dart';
import 'package:chs_connect/constants/chs_images.dart';
import 'package:chs_connect/services/chs_auth.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:chs_connect/utils/chs_page_transitions.dart';
import 'package:chs_connect/utils/chs_user_cache.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Splash extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  static ChsThemeModel theme = ChsThemeModel();
  static ChsUserCache userCache;

  Splash({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    userCache = Provider.of<ChsUserCache>(context);
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
    bool verified = user?.isEmailVerified;
    if (user != null) {
      userCache.changeName(user.displayName);
      userCache.changePhotoUrl(user.photoUrl);
      userCache.changeEmail(user.email);
      if (verified) {
        ChsAuth.setUser(user);
        Future.delayed(Duration(milliseconds: 1000)).then((_) {
          RoutePredicate predicate = (Route<dynamic> route) => false;
          Navigator.pushAndRemoveUntil(
              context,
              ChsPageRoute.slideIn<void>(ListenableProvider<ChsThemeModel>(
                builder: (_) => theme..init(),
                child: Consumer<ChsThemeModel>(
                  builder: (context, model, child) {
                    return Theme(
                      data: model.theme,
                      child: MainPage(),
                    );
                  },
                ),
              )),
              predicate);
        });
      } else {
        Future.delayed(Duration(milliseconds: 1000)).then((_) {
          RoutePredicate predicate = (Route<dynamic> route) => false;
          Navigator.pushAndRemoveUntil(
              context,
              ChsPageRoute.fadeIn<void>(
                Verify(
                  userCache: userCache,
                ),
              ),
              predicate);
        });
      }
    } else {
      Future.delayed(Duration(milliseconds: 1000)).then((_) {
        RoutePredicate predicate = (Route<dynamic> route) => false;
        Navigator.pushAndRemoveUntil(
            context,
            ChsPageRoute.fadeIn<void>(Welcome()),
            predicate);
      });
    }
  }
}
