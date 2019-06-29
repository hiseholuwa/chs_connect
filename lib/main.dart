import 'dart:io';

import 'package:chs_connect/app/app.dart';
import 'package:chs_connect/services/chs_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future main() async {
  await ChsSettings.initVersion();
  _setTargetPlatform();
  runApp(App());
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
