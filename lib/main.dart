import 'dart:io';

import 'package:chs_connect/app/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future main() async {
  final BootstrapModel bs = await App.bootstrap();
  _setTargetPlatform();
  runApp(App(isFirstTime: bs.isFirstTime,));
}

void _setTargetPlatform() {
  TargetPlatform targetPlatform;
  if(Platform.isMacOS){
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isAndroid) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}
