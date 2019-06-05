import 'package:chs_connect/app/auth/blocs/auth_provider.dart';
import 'package:chs_connect/app/auth/tools/card_clipper.dart';
import 'package:chs_connect/constants/chs_strings.dart';
import 'package:chs_connect/constants/chs_colors.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RegisterCard extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  RegisterCard({Key key, this.analytics, this.observer}) : super(key:key);

  @override
  State<StatefulWidget> createState() {
    return _RegisterCardState(analytics, observer);
  }
}

class _RegisterCardState extends State<RegisterCard>
    with SingleTickerProviderStateMixin {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  _RegisterCardState(this.analytics, this.observer);

  var deviceSize;
  var height;
  var width;
  AnimationController controller;
  Animation<double> animation;
  TextEditingController userNameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var img;

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    height = deviceSize.height;
    width = deviceSize.width;
    final bloc = AuthProvider.of(context);
    return registerCard(bloc);
  }

  Widget registerCard(AuthBloc bloc) {
    return Container(
      margin: EdgeInsets.only(top: deviceSize.height / 10),
      child: Opacity(
        opacity: animation.value,
        child: SizedBox(
            width: deviceSize.width * 0.85,
            child: Column(
              children: <Widget>[
                Center(
                  child: CircleAvatar(
                    backgroundColor: ChsColors.default_accent,
                    radius: height * 0.1,
                    child: GestureDetector(
                        onTap: (){},
                        child: Icon(
                          Icons.add_a_photo,
                          size: deviceSize.height * 0.1,
                          color: Colors.white,
                        )
                    ),
                  ),
                ),
                ClipPath(
                  clipper: CardClipper(),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Card(
                    color: Colors.white,
                    elevation: 1.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: registerBuilder(bloc),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget registerBuilder(AuthBloc bloc) {
    return Form(
      child: Padding(
        padding: EdgeInsets.only(
          left: height * 0.03,
          right: height * 0.03,
          bottom: height * 0.03,
          top: height * 0.05,
        ),
        child: new Column(
          children: <Widget>[
            userNameField(bloc),
            SizedBox(
              height: height * 0.02,
            ),
            fullNameField(bloc),
            SizedBox(
              height: height * 0.02,
            ),
            emailField(bloc),
            SizedBox(
              height: height * 0.02,
            ),
            passwordField(bloc),
            SizedBox(
              height: height * 0.025,
            ),
            submitBtn(bloc),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(ChsStrings.sign_in,
                  style: TextStyle(color: ChsColors.default_accent, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
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
//    _loadFirestore();
  }

  Widget userNameField(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.userName,
      builder: (context, snapshot) {
        return TextField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          controller: userNameController,
          onChanged: bloc.changeUserName,
          style: new TextStyle(
            fontSize: 17.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: ChsStrings.enter_username_hint,
            contentPadding: EdgeInsets.fromLTRB(
                height * 0.025, height * 0.012, height * 0.025, height * 0.012),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(height * 0.05),
            ),
            errorText: snapshot.error,
            filled: true,
            fillColor: Color(0xffeeeeee),
          ),
        );
      },
    );
  }

  Widget fullNameField(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.fullName,
      builder: (context, snapshot) {
        return TextField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          controller: fullNameController,
          onChanged: bloc.changeFullName,
          style: new TextStyle(
            fontSize: 17.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: ChsStrings.enter_full_name_hint,
            contentPadding: EdgeInsets.fromLTRB(
                height * 0.025, height * 0.012, height * 0.025, height * 0.012),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(height * 0.05),
            ),
            errorText: snapshot.error,
            filled: true,
            fillColor: Color(0xffeeeeee),
          ),
        );
      },
    );
  }

  Widget emailField(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot) {
        return TextField(
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          controller: emailController,
          onChanged: bloc.changeEmail,
          style: new TextStyle(
            fontSize: 17.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: ChsStrings.enter_email_hint,
            contentPadding: EdgeInsets.fromLTRB(
                height * 0.025, height * 0.012, height * 0.025, height * 0.012),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(height * 0.05),
            ),
            filled: true,
            fillColor: Color(0xffeeeeee),
            errorText: snapshot.error,
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
          textInputAction: TextInputAction.done,
          controller: passwordController,
          onChanged: bloc.changePassword,
          obscureText: true,
          decoration: InputDecoration(
            hintText: ChsStrings.enter_password_hint,
            contentPadding: EdgeInsets.fromLTRB(
                height * 0.025, height * 0.012, height * 0.025, height * 0.012),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(height * 0.05),
            ),
            errorText: snapshot.error,
            filled: true,
            fillColor: Color(0xffeeeeee),
          ),
        );
      },
    );
  }

  Widget submitBtn(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: height * 0.015,
            right: height * 0.015,
          ),
          child: RaisedButton(
            padding: EdgeInsets.symmetric(vertical: height * 0.02),
            color: ChsColors.default_accent,
            onPressed: snapshot.hasData
                ? () {
              register();
            }
                : null,
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(height * 0.05))),
            child: Text(ChsStrings.create,
                style: TextStyle(color: Colors.white, fontSize: 17)),
          ),
        );
      },
    );
  }

  Future<void> register() async {
    FocusScope.of(context).requestFocus(new FocusNode());
//    String userName = userNameController.text.toString().trim();
//    String fullName = fullNameController.text.toString();
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
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
