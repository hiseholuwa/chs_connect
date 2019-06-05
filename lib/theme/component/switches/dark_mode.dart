import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    Widget title =  Text("Dark Mode", style: theme.theme.textTheme.body1,);
    return new Consumer<ChsThemeModel>(
        builder: (context, model, child) => Container(
          child: ListTile(
            leading: leading,
            subtitle: subtitle,
            title: title,
            trailing: Switch.adaptive(
              activeColor: theme.accentColor,
              value: model.darkMode,
              onChanged: model.changeDarkMode,
            ),
          ),
        ));
  }
}