import 'package:chs_connect/app/auth/blocs/auth_provider.dart';
import 'package:chs_connect/app/auth/login.dart';
import 'package:chs_connect/app/main/main.dart';
import 'package:chs_connect/constants/chs_colors.dart';
import 'package:chs_connect/constants/chs_images.dart';
import 'package:chs_connect/constants/chs_strings.dart';
import 'package:chs_connect/rebloc/actions/common.dart';
import 'package:chs_connect/rebloc/states/main.dart';
import 'package:chs_connect/rebloc/view_models/settings.dart';
import 'package:chs_connect/services/chs_auth.dart';
import 'package:chs_connect/services/chs_settings.dart';
import 'package:chs_connect/utils/chs_page_transitions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rebloc/rebloc.dart';

class Welcome extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  const Welcome({Key key, this.analytics, this.observer}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WelcomeState(analytics, observer);
  }
}
class _WelcomeState extends State<Welcome> {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  _WelcomeState(this.analytics, this.observer);
  bool isLoading;

    Widget welcomeScreen (BuildContext context) {
      var deviceSize = MediaQuery.of(context).size;
      return Scaffold(
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
              emailBtn(deviceSize, context, this.analytics, this.observer),
              googleBtn(deviceSize),
              Container(
                height: deviceSize.height / 20,
              ),
              Center(
                child:  ChsSettings.getVersion() != null ? Text("v"+ChsSettings.getVersion(), style: TextStyle(color: Colors.grey, fontSize: 17),) : const SizedBox(),
              ),
              Center(
                child: Text(ChsStrings.me,
                    style: TextStyle(color: Colors.grey, fontSize: 17)),
              ),

            ],
          ),
      );
    }

    Widget emailBtn(size, context, anal, observe) {
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
            Navigator.push(context,ChsPageRoute.fadeIn<void>(AuthProvider(child: LoginPage(analytics: analytics, observer: observer,),)));
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(height * 0.05)),
              ),
          child: Row(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(left: width * 0.05),),
              Icon(Icons.email, color: Colors.white,),
              Padding(padding: EdgeInsets.only(left: width * 0.1),),
              Text(ChsStrings.login_email,
                  style: TextStyle(color: Colors.white, fontSize: 17)),
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
            setState(() => isLoading = true);
            try {
              _login();
            } catch(e) {
              setState(() => isLoading = false);
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
              Padding(padding: EdgeInsets.only(left: width * 0.05),),
              Image.asset(ChsImages.google_icon, width: 24,),
              Padding(padding: EdgeInsets.only(left: width * 0.1),),
              Text(ChsStrings.login_google,
                  style: TextStyle(color: Colors.white, fontSize: 17)),
            ],
          ),
        ),
      );
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
          }
      );
      FirebaseUser user;
      try {
        user = await ChsAuth.signInWithGoogle();
      }catch(e){
        Navigator.pop(context);
        var message = ChsAuth.getExceptionString(e);
        Flushbar(
          message: message,
          isDismissible: true,
          duration: Duration(seconds: 4),
          icon: Icon(Icons.error, color: Colors.red,),
          aroundPadding: EdgeInsets.all(8),
          borderRadius: 8,
        )..show(context);
      }
      if(user != null){
        setState(() => isLoading = false);
        WidgetsBinding.instance.addPostFrameCallback((_) async{
          StoreProvider.of<ChsAppState>(context).dispatcher(ChsOnLoginAction(user));
          RoutePredicate predicate = (Route<dynamic> route) => false;
          Navigator.pushAndRemoveUntil<void>(context, ChsPageRoute.fadeIn<void>(MainPage(analytics: analytics, observer: observer,)), predicate);
        });
      }

//      return await ChsAuth.signInWithGoogle().catchError((dynamic e) async {
//        if(e.message.isNotEmpty) {
//          Flushbar(
//            message: e.message,
//            icon: Icon(Icons.error),
//            aroundPadding: EdgeInsets.all(8),
//            borderRadius: 8,
//          );
//        }
//        if(!mounted){
//          return;
//        }
//        if (ChsAuth.getUser != null) {
//          setState(() => isLoading = false);
//          WidgetsBinding.instance.addPostFrameCallback((_) async{
//            StoreProvider.of<ChsAppState>(context).dispatcher(ChsOnLoginAction(ChsAuth.getUser));
//            RoutePredicate predicate = (Route<dynamic> route) => false;
//            Navigator.pushAndRemoveUntil<void>(context, ChsPageRoute.fadeIn<void>(MainPage(analytics: analytics, observer: observer,)), predicate);
//          });
//        }
//      });
    }

    Future<void> _analyticsSetup() async {
      await analytics.setCurrentScreen(
          screenName: 'Welcome Screen', screenClassOverride: 'WelcomeScreenClass');
    }

    @override
    Widget build(BuildContext context) {
      return ViewModelSubscriber<ChsAppState, ChsSettingsViewModel>(
        converter: (store) => ChsSettingsViewModel(store),
        builder: (BuildContext context, DispatchFunction dispatcher, ChsSettingsViewModel vm){
          return welcomeScreen(context);
        },
      );

    }

//    Future<void> authState() async {
////      showDialog(
////          context: context,
////          barrierDismissible: true,
////          builder: (context) {
////            return SpinKitWave(
////              color: Colors.white,
////              type: SpinKitWaveType.start,
////            );
////          }
////      );
//      FirebaseAuth auth = FirebaseAuth.instance;
//      FirebaseUser user = await auth.currentUser();
//      if (user != null) {
//        WidgetsBinding.instance.addPostFrameCallback((_) async {
//          StoreProvider.of<ChsAppState>(context).dispatcher(
//              ChsOnLoginAction(user));
//          RoutePredicate predicate = (Route<dynamic> route) => false;
//          Navigator.pushAndRemoveUntil<void>(context, ChsPageRoute.fadeIn<void>(
//              MainPage(analytics: analytics, observer: observer,)), predicate);
//        });
//      }
//    }

    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    }
    @override
    void initState()  {
      super.initState();
      _analyticsSetup();
      isLoading = false;
//      authState();
    }
  }