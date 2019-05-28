import 'package:chs_connect/constants/chs_colors.dart';
import 'package:chs_connect/constants/chs_images.dart';
import 'package:chs_connect/constants/chs_routes.dart';
import 'package:chs_connect/constants/chs_strings.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  Welcome();

  Widget welcomeScreen (BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xffeeeeee),
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
            Center(
              child: Text(ChsStrings.me,
                  style: TextStyle(color: Colors.grey, fontSize: 17)),
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
        color: ChsColors.default_blue,
        padding: EdgeInsets.symmetric(vertical: height * 0.02),
        onPressed: () {
          Navigator.pushNamed(context, ChsRoutes.loginPageRoute);
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
        color: ChsColors.default_blue,
        padding: EdgeInsets.symmetric(vertical: height * 0.02),
        onPressed: () {
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

  @override
  Widget build(BuildContext context) {
    return welcomeScreen(context);

  }
}