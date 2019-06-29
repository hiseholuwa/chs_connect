import 'package:chs_connect/app/auth/components/auth_bkg.dart';
import 'package:chs_connect/app/auth/components/recovery_card.dart';
import 'package:flutter/material.dart';

class RecoveryWidget extends StatelessWidget {

  RecoveryWidget();

  Widget buildLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          AuthBackground(),
          RecoveryCard(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildLayout(context);
  }
}
