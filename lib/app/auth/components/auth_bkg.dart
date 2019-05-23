import 'package:chs_connect/app/auth/tools/arc_clipper.dart';
import 'package:chs_connect/app/auth/components/auth_wave.dart';
import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  AuthBackground();

  Widget bkgLayout(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return SizedBox(
      height: deviceSize.height,
      width: deviceSize.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipPath(
                clipper: ArcClipper(),
                child: Stack(
                  children: <Widget>[
                    Container(
                      color: Colors.grey[900],
                      height: deviceSize.height / 2,
                      width: deviceSize.width,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: deviceSize.height * 0.4,
          ),
          AuthWave(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return bkgLayout(context);
  }
}
