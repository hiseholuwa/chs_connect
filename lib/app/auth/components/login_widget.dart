import 'package:chs_connect/app/auth/components/auth_bkg.dart';
import 'package:chs_connect/app/auth/components/login_card.dart';
import 'package:flutter/material.dart';

class LoginWidget extends StatelessWidget {
  LoginWidget();

  Widget buildLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          AuthBackground(),
          LoginCard(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildLayout(context);
  }
}
