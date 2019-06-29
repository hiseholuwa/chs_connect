import 'package:chs_connect/app/auth/blocs/auth_provider.dart';
import 'package:chs_connect/app/auth/extra.dart';
import 'package:chs_connect/app/auth/login.dart';
import 'package:chs_connect/app/auth/verify.dart';
import 'package:chs_connect/app/main/main.dart';
import 'package:chs_connect/constants/chs_colors.dart';
import 'package:chs_connect/constants/chs_constants.dart';
import 'package:chs_connect/constants/chs_images.dart';
import 'package:chs_connect/constants/chs_strings.dart';
import 'package:chs_connect/services/chs_auth.dart';
import 'package:chs_connect/services/chs_cloud_messaging.dart';
import 'package:chs_connect/services/chs_firestore.dart';
import 'package:chs_connect/services/chs_settings.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:chs_connect/utils/chs_page_transitions.dart';
import 'package:chs_connect/utils/chs_preferences.dart';
import 'package:chs_connect/utils/chs_user_cache.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Welcome extends StatefulWidget {

  const Welcome({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WelcomeState();
  }
}

class _WelcomeState extends State<Welcome> {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  static ChsThemeModel theme = ChsThemeModel();
  ChsUserCache userCache;

  _WelcomeState();

  Widget welcomeScreen(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ChsColors.default_scaffold,
      body: Column(
        children: <Widget>[
          Container(
            height: deviceSize.height / 4,
          ),
          Center(
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: deviceSize.height * 0.18,
              child: Image.asset(ChsImages.auth_logo),
            ),
          ),
          Container(
            height: deviceSize.height / 15,
          ),
          emailBtn(deviceSize, context),
          googleBtn(deviceSize),
          Container(
            height: deviceSize.height / 20,
          ),
          Center(
            child: ChsSettings.getVersion() != null
                ? Text(
                    "v" + ChsSettings.getVersion(),
                    style: TextStyle(color: Colors.grey, fontSize: 17),
                  )
                : const SizedBox(),
          ),
          Center(
            child: Text(ChsStrings.me, style: TextStyle(color: Colors.grey, fontSize: 17)),
          ),
        ],
      ),
    );
  }

  Widget emailBtn(size, context) {
    var height = size.height;
    var width = size.width;
    return Container(
      width: width * 0.8,
      padding: EdgeInsets.only(
        top: 5,
        bottom: height * 0.015,
        left: height * 0.015,
        right: height * 0.015,
      ),
      child: RaisedButton(
        color: ChsColors.default_accent,
        padding: EdgeInsets.symmetric(vertical: height * 0.02),
        onPressed: () {
          Navigator.push(
              context,
              ChsPageRoute.fadeIn<void>(AuthProvider(
                child: LoginPage(),
              )));
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(height * 0.05)),
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: width * 0.05),
            ),
            Icon(
              Icons.email,
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.1),
            ),
            Text(ChsStrings.login_email, style: TextStyle(color: Colors.white, fontSize: 17)),
          ],
        ),
      ),
    );
  }

  Widget googleBtn(size) {
    var height = size.height;
    var width = size.width;
    return Container(
      width: width * 0.8,
      padding: EdgeInsets.only(
        top: 5,
        bottom: height * 0.015,
        left: height * 0.015,
        right: height * 0.015,
      ),
      child: RaisedButton(
        color: ChsColors.default_accent,
        padding: EdgeInsets.symmetric(vertical: height * 0.02),
        onPressed: () {
          try {
            _login();
          } catch (e) {
            Flushbar(
              message: e.toString(),
              icon: Icon(Icons.error),
              aroundPadding: EdgeInsets.all(8),
              borderRadius: 8,
            );
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(height * 0.05)),
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: width * 0.05),
            ),
            Image.asset(
              ChsImages.google_icon,
              width: 24,
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.1),
            ),
            Text(ChsStrings.login_google, style: TextStyle(color: Colors.white, fontSize: 17)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    userCache = Provider.of<ChsUserCache>(context);
    return welcomeScreen(context);
  }

  @override
  void initState() {
    super.initState();
    _analyticsSetup();
    changeStatusBar();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _analyticsSetup() async {
    await analytics.setCurrentScreen(screenName: 'Welcome Screen', screenClassOverride: 'WelcomeScreenClass');
  }

  void changeStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark));
  }

  Future<void> _login() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return SpinKitWave(
            color: Colors.white,
            type: SpinKitWaveType.start,
          );
        });
    FirebaseUser user;
    bool newUser;
    bool verified;
    try {
      user = await ChsAuth.signInWithGoogle();
      newUser = ChsAuth.newUser();
      verified = user.isEmailVerified;
    } catch (e) {
      Navigator.pop(context);
      var message = ChsAuth.getExceptionString(e);
      Flushbar(
        message: message,
        isDismissible: true,
        duration: Duration(seconds: 4),
        icon: Icon(
          Icons.error,
          color: Colors.red,
        ),
        aroundPadding: EdgeInsets.all(8),
        borderRadius: 8,
      )..show(context);
    }
    if (user != null) {
      if (newUser) {
        ChsPreferences.setBool(IS_FIRST_TIME_LOGIN, true);
        await analytics.logSignUp(signUpMethod: 'Google');
        userCache.changeName(user.displayName);
        userCache.changePhotoUrl(user.photoUrl);
        userCache.changeEmail(user.email);
        ChsFirestore.token.setData(ChsFCM.tokenToMap());
        RoutePredicate predicate = (Route<dynamic> route) => false;
        Navigator.pushAndRemoveUntil(
            context,
            ChsPageRoute.fadeIn<void>(
              AuthProvider(
                child: ExtraPage(),
              ),
            ),
            predicate);
      } else {
        if (verified) {
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
        } else {
          ChsAuth.verifyEmail();
          RoutePredicate predicate = (Route<dynamic> route) => false;
          Navigator.pushAndRemoveUntil(
              context,
              ChsPageRoute.fadeIn<void>(Verify(
                userCache: userCache,
              )),
              predicate);
        }
      }
    }
  }
}
