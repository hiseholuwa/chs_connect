import 'package:chs_connect/app/app.dart';
import 'package:flutter/material.dart';

Future main() async {
  final BootstrapModel bs = await App.bootstrap();
  runApp(App(isFirstTime: bs.isFirstTime,));
}
