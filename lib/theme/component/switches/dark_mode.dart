import 'package:chs_connect/constants/chs_strings.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


class DarkModeSwitch extends StatelessWidget {
  const DarkModeSwitch({
    this.leading,
    this.subtitle,
  });

  final Widget leading, subtitle;

  @override
  Widget build(BuildContext context) {
    ChsThemeModel theme = Provider.of<ChsThemeModel>(context);
    Widget title =  Text(ChsStrings.dark_mode, style: theme.theme.textTheme.body1,);
    return new Consumer<ChsThemeModel>(
        builder: (context, model, child) => Container(
          child: ListTile(
            leading: leading,
            subtitle: subtitle,
            title: title,
            trailing: Switch.adaptive(
              activeColor: theme.theme.accentColor,
              value: model.darkMode,
              onChanged: (value){
                model.changeDarkMode(value);
                if(!value){
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                      statusBarColor: Colors.white,
                      statusBarIconBrightness: Brightness.dark
                  ));
                } else {
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.light
                  ));
                }
              },
            ),
          ),
        ));
  }
}