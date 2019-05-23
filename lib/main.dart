import 'package:chs_connect/models/chs_base_model.dart';
import 'package:chs_connect/app/app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  ChsStateModel model = ChsStateModel(_prefs);
  runApp(App(model: model));
}
