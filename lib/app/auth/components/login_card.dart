import 'package:chs_connect/app/auth/blocs/auth_provider.dart';
import 'package:chs_connect/app/auth/recovery.dart';
import 'package:chs_connect/app/auth/register.dart';
import 'package:chs_connect/app/auth/verify.dart';
import 'package:chs_connect/app/main/main.dart';
import 'package:chs_connect/constants/chs_colors.dart';
import 'package:chs_connect/constants/chs_images.dart';
import 'package:chs_connect/constants/chs_strings.dart';
import 'package:chs_connect/services/chs_auth.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:chs_connect/utils/chs_page_transitions.dart';
import 'package:chs_connect/utils/chs_user_cache.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginCard extends StatefulWidget {
  const LoginCard({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginCardState();
  }
}

class _LoginCardState extends State<LoginCard> with SingleTickerProviderStateMixin {
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  _LoginCardState();

  var deviceSize;
  var height;
  var width;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AnimationController controller;
  Animation<double> animation;
  ChsUserCache userCache;
  static ChsThemeModel theme = ChsThemeModel();
  static Icon eye = Icon(
    CommunityMaterialIcons.eye,
    color: ChsColors.default_accent,
  );
  static Icon eyeOff = Icon(
    CommunityMaterialIcons.eye_off,
    color: ChsColors.default_accent,
  );
  Icon suffix = eye;
  bool obscure = true;

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
              onPressed: () {
                Navigator.push(
                    context,
                    ChsPageRoute.slideIn<void>(AuthProvider(
                      child: RecoveryPage(),
                    )));
              },
              child: Text(ChsStrings.forgot, style: TextStyle(color: ChsColors.default_accent, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
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
            contentPadding: EdgeInsets.fromLTRB(height * 0.025, height * 0.012, height * 0.025, height * 0.012),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(height * 0.1),
            ),
            filled: true,
            fillColor: Color(0xffeeeeee),
            prefixIcon: Icon(
              Icons.email,
              color: ChsColors.default_accent,
            ),
            hintStyle: TextStyle(color: Colors.black38),
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
              contentPadding: EdgeInsets.fromLTRB(height * 0.025, height * 0.012, height * 0.025, height * 0.012),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(height * 0.1),
              ),
              filled: true,
              fillColor: Color(0xffeeeeee),
              hintStyle: TextStyle(color: Colors.black38),
              prefixIcon: Icon(
                Icons.lock,
                color: ChsColors.default_accent,
              ),
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
            disabledColor: Colors.grey[200],
            padding: EdgeInsets.symmetric(vertical: height * 0.02),
            color: ChsColors.default_accent,
            onPressed: snapshot.hasData
                ? () {
              loginUser();
            }
                : null,
            elevation: 11,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(height * 0.05))),
            child: Text(ChsStrings.login, style: TextStyle(color: Colors.white, fontSize: 17)),
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
          Navigator.push(
              context,
              ChsPageRoute.slideIn<void>(AuthProvider(
                child: RegisterPage(),
              )));
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(height * 0.05)),
            side: BorderSide(
              color: ChsColors.default_accent,
            )),
        child: Text(ChsStrings.register, style: TextStyle(color: ChsColors.default_accent, fontSize: 17)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery
        .of(context)
        .size;
    height = deviceSize.height;
    width = deviceSize.width;
    final bloc = AuthProvider.of(context);
    userCache = Provider.of<ChsUserCache>(context);
    return loginCard(bloc);
  }

  @override
  void initState() {
    super.initState();
    setupControllers();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _obscureToggle() {
    setState(() {
      obscure = !obscure;
      suffix == eye ? suffix = eyeOff : suffix = eye;
    });
  }

  void setupControllers() {
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
      )
        ..show(context);
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
      )
        ..show(context);
    }
  }

  Future<void> loginUser() async {
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString();

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
      FirebaseUser authUser = await ChsAuth.signInWithEmail(email, password);
      bool verified = await ChsAuth.userVerified(authUser);
      if (authUser != null) {
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
          RoutePredicate predicate = (Route<dynamic> route) => false;
          Navigator.pushAndRemoveUntil(
              context,
              ChsPageRoute.fadeIn<void>(
                Verify(
                  userCache: userCache,
                ),
              ),
              predicate);
        }
      }
    } catch (e) {
      print(e);
      String error = ChsAuth.getExceptionString(e);
      Navigator.pop(context);
      snackBar(true, error);
    }
  }
}
