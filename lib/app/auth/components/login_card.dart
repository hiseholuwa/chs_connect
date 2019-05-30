import 'package:chs_connect/app/auth/register.dart';
import 'package:chs_connect/constants/chs_colors.dart';
import 'package:chs_connect/constants/chs_strings.dart';
import 'package:chs_connect/app/auth/blocs/auth_provider.dart';
import 'package:chs_connect/constants/chs_images.dart';
import 'package:chs_connect/utils/chs_page_transitions.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginCard extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  const LoginCard({Key key, this.analytics, this.observer}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginCardState(analytics, observer);
  }
}

class _LoginCardState extends State<LoginCard>
    with SingleTickerProviderStateMixin {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  _LoginCardState(this.analytics, this.observer);

  var deviceSize;
  var height;
  var width;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AnimationController controller;
  Animation<double> animation;
  static Icon eye = Icon(CommunityMaterialIcons.eye);
  static Icon eyeOff = Icon(CommunityMaterialIcons.eye_off);
  Icon suffix = eye;
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    height = deviceSize.height;
    width = deviceSize.width;
    final bloc = AuthProvider.of(context);
    return loginCard(bloc);
  }

  Widget loginCard(AuthBloc bloc) {
    return Container(
      margin: EdgeInsets.only(top: deviceSize.height / 20),
      child: Opacity(
        opacity: animation.value,
        child: SizedBox(
          width: deviceSize.width * 0.85,
          child: Column(
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: deviceSize.height * 0.15,
//                  width: deviceSize.width * 0.35,
                  child: Image.asset(ChsImages.auth_logo),
                ),
              ),
              Card(
                color: Colors.white,
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: loginBuilder(bloc),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginBuilder(AuthBloc bloc) {
    return Form(
      child: Padding(
        padding: EdgeInsets.only(
          left: height * 0.03,
          right: height * 0.03,
          bottom: height * 0.02,
          top: height * 0.04,
        ),
        child: new Column(
          children: <Widget>[
            emailField(bloc),
            SizedBox(
              height: height * 0.02,
            ),
            passwordField(bloc),
            SizedBox(
              height: height * 0.02,
            ),
            loginBtn(bloc),
            registerBtn(),
            FlatButton(
              onPressed: () {},
              child: Text(ChsStrings.forgot,
                  style: TextStyle(color: ChsColors.default_blue, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  void _obscureToggle() {
    setState(() {
      obscure = !obscure;
      suffix == eye ? suffix = eyeOff : suffix = eye;
    });
  }

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 1500),
    );
    animation = new Tween(begin: 0.0, end: 1.0).animate(
      new CurvedAnimation(
        parent: controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation.addListener(() => this.setState(() {}));
    controller.forward();
  }

  Widget emailField(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot) {
        return TextField(
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: bloc.changeEmail,
          controller: emailController,
          style: new TextStyle(
            fontSize: 17.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: ChsStrings.enter_email_hint,
            errorText: snapshot.error,
            contentPadding: EdgeInsets.fromLTRB(
                height * 0.025, height * 0.012, height * 0.025, height * 0.012),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(40.0),
            ),
            filled: true,
            fillColor: Color(0xffeeeeee),
            prefixIcon: Icon(Icons.email),
          ),
        );
      },
    );
  }

  Widget passwordField(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.password,
      builder: (context, snapshot) {
        return TextField(
          style: new TextStyle(
            fontSize: 17.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              hintText: ChsStrings.enter_password_hint,
              errorText: snapshot.error,
              contentPadding: EdgeInsets.fromLTRB(height * 0.025,
                  height * 0.012, height * 0.025, height * 0.012),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(height * 0.05),
              ),
              filled: true,
              fillColor: Color(0xffeeeeee),
              prefixIcon: Icon(Icons.lock),
              suffixIcon: GestureDetector(
                child: suffix,
                onTap: _obscureToggle,
              )),
          obscureText: obscure,
          onChanged: bloc.changePassword,
          controller: passwordController,
        );
      },
    );
  }

  Widget loginBtn(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.loginValid,
      builder: (context, snapshot) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: 5,
            bottom: height * 0.015,
            left: height * 0.015,
            right: height * 0.015,
          ),
          child: RaisedButton(
            padding: EdgeInsets.symmetric(vertical: height * 0.02),
            color: ChsColors.default_blue,
            onPressed: snapshot.hasData
                ? () {
              loginUser();
            }
                : null,
            elevation: 11,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(height * 0.05))),
            child: Text(ChsStrings.login,
                style: TextStyle(color: Colors.white, fontSize: 17)),
          ),
        );
      },
    );
  }

  Widget registerBtn() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 5,
        bottom: height * 0.002,
        left: height * 0.015,
        right: height * 0.015,
      ),
      child: FlatButton(
        padding: EdgeInsets.symmetric(vertical: height * 0.02),
        onPressed: () {
          Navigator.push(context, ChsPageRoute.slideIn<void>(AuthProvider(child: RegisterPage(analytics: analytics, observer: observer,),)));
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(height * 0.05)),
            side: BorderSide(
              color: ChsColors.default_blue,
            )),
        child: Text(ChsStrings.register,
            style: TextStyle(color: ChsColors.default_blue, fontSize: 17)),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
//    String email = emailController.text.toString().trim();
//    String password = passwordController.text.toString();

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return SpinKitWave(
            color: Colors.white,
            type: SpinKitWaveType.start,
          );
        });

//    try {
//      FirebaseApi api = await FirebaseApi.signIn(email, password);
//      if (api != null) {
//        if (api.firebaseUser.isEmailVerified) {
//          RoutePredicate predicate = (Route<dynamic> route) => false;
//          Navigator.pushNamedAndRemoveUntil(
//              context, UIData.mainPageRoute, predicate);
//        } else {
//          Navigator.pop(context);
//          var snackbar = SnackBar(
//            content: Text(
//              UIData.snackbar_chk_verification_err,
//              style: TextStyle(color: Colors.white),
//            ),
//            backgroundColor: Colors.black,
//            duration: Duration(seconds: 2, milliseconds: 500),
//          );
//          Scaffold.of(context).showSnackBar(snackbar);
//        }
//      }
//    } catch (e) {
//      print(e);
//      String error = FirebaseApi.getExceptionString(e);
//      Navigator.pop(context);
//      var snackbar = SnackBar(
//        content: Text(
//          error,
//          style: TextStyle(color: Colors.white),
//        ),
//        backgroundColor: Colors.black,
//        duration: Duration(seconds: 2, milliseconds: 500),
//      );
//      Scaffold.of(context).showSnackBar(snackbar);
//    }
  }
}
