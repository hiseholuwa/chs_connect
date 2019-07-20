import 'package:chs_connect/app/main/main.dart';
import 'package:chs_connect/constants/chs_assets.dart';
import 'package:chs_connect/constants/chs_colors.dart';
import 'package:chs_connect/constants/chs_strings.dart';
import 'package:chs_connect/services/chs_auth.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:chs_connect/utils/chs_page_transitions.dart';
import 'package:chs_connect/utils/chs_user_cache.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lottie/flutter_lottie.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class Verify extends StatefulWidget {
  final ChsUserCache userCache;

  const Verify({Key key, this.userCache}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VerifyState(userCache);
  }
}

class _VerifyState extends State<Verify> with WidgetsBindingObserver {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  final ChsUserCache userCache;
  static ChsThemeModel theme = ChsThemeModel();
  LottieController controller;
  String name;

  _VerifyState(this.userCache);

  Widget verifyScreen(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ChsColors.default_scaffold,
      body: Column(
        children: <Widget>[
          Container(
            height: deviceSize.height / 8,
          ),
          SizedBox(
            width: deviceSize.width,
            height: deviceSize.height * 0.4,
            child: LottieView.fromFile(
              loop: true,
              filePath: ChsAssets.mail_anim,
              autoPlay: true,
              onViewCreated: onViewCreatedFile,
            ),
          ),
          Text(ChsStrings.verifyScreenText1(name)),
          Text(ChsStrings.verify_screen_text2),
          Padding(
            padding: EdgeInsets.only(bottom: deviceSize.height * 0.05),
          ),
          Text(ChsStrings.verify_screen_text3),
          Padding(
            padding: EdgeInsets.only(bottom: deviceSize.height * 0.01),
          ),
          verifyBtn(deviceSize),
          Padding(
            padding: EdgeInsets.only(bottom: deviceSize.height * 0.02),
          ),
          Text(ChsStrings.verify_screen_text4),
          verifiedBtn(deviceSize),
        ],
      ),
    );
  }

  Widget verifyBtn(size) {
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
          _verify();
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
              padding: EdgeInsets.only(left: width * 0.06),
            ),
            Text(ChsStrings.verification_btn, style: TextStyle(color: Colors.white, fontSize: 17)),
          ],
        ),
      ),
    );
  }

  Widget verifiedBtn(size) {
    var height = size.height;
    var width = size.width;
    return Container(
      width: width * 0.6,
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
          checkVerification();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(height * 0.05)),
        ),
        child: Text(ChsStrings.verification_chk_btn, style: TextStyle(color: Colors.white, fontSize: 17)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    name = userCache.name.split(" ")[0];
    return verifyScreen(context);
  }

  @override
  void initState() {
    super.initState();
    _analyticsSetup();
    changeStatusBar();
    reloadUser();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  Future<void> _analyticsSetup() async {
    await analytics.setCurrentScreen(screenName: 'Verify Screen', screenClassOverride: 'VerifyScreenClass');
  }

  void onViewCreatedFile(LottieController controller) {
    this.controller = controller;
  }

  void reloadUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    user.reload();
  }

  void snackBar(bool error, String message) {
    if (error) {
      Flushbar(
        message: message,
        icon: Icon(
          Icons.error,
          color: Colors.red,
        ),
        aroundPadding: EdgeInsets.all(8),
        borderRadius: 8,
        backgroundColor: ChsColors.dark_bkg,
        duration: Duration(seconds: 3),
      )..show(context);
    } else {
      Flushbar(
        message: message,
        icon: Icon(
          Icons.check_circle_outline,
          color: Colors.green,
        ),
        aroundPadding: EdgeInsets.all(8),
        borderRadius: 8,
        backgroundColor: ChsColors.dark_bkg,
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  Future<void> _verify() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return SpinKitWave(
            color: Colors.white,
            type: SpinKitWaveType.start,
          );
        });
    try {
      bool sent = await ChsAuth.verifyEmail();
      if (sent) {
        Navigator.pop(context);
        snackBar(false, ChsStrings.snackbar_verification);
      }
    } catch (e) {
      Navigator.pop(context);
      var message = ChsAuth.getExceptionString(e);
      snackBar(true, message);
    }
  }

  void checkVerification() async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return SpinKitWave(
            color: Colors.white,
            type: SpinKitWaveType.start,
          );
        });

    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      user.reload();
      user = await FirebaseAuth.instance.currentUser();
      ChsAuth.setUser(user);
      bool verified = user.isEmailVerified;
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
        Navigator.pop(context);
        snackBar(true, ChsStrings.snackbar_chk_verification_err);
      }
    } on PlatformException catch (e) {
      if (e.message != null) {
        snackBar(true, e.message);
      }
    }
  }

  void changeStatusBar() async {
    await FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    await FlutterStatusbarcolor.setNavigationBarColor(Colors.white);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        user.reload();
        ChsAuth.setUser(user);
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        user.reload();
        ChsAuth.setUser(user);
        break;
      case AppLifecycleState.suspending:
        break;
    }
  }
}
