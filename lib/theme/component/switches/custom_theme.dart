import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CustomThemeSwitch extends StatelessWidget {
  const CustomThemeSwitch({
    this.leading,
    this.subtitle,
    this.showOnlyLightMode = true,
  });

  final Widget leading, subtitle;
  final bool showOnlyLightMode;

  @override
  Widget build(BuildContext context) {
    ChsThemeModel theme = Provider.of<ChsThemeModel>(context);
    Widget title =  Text("Custom Mode", style: theme.theme.textTheme.body1,);
    return new Consumer<ChsThemeModel>(
        builder: (context, model, child) => Container(
          child: !showOnlyLightMode || !model.darkMode && showOnlyLightMode
              ? ListTile(
            leading: leading,
            subtitle: subtitle,
            title: title,
            trailing: Switch.adaptive(
              activeColor: theme.accentColor,
              value: model.customTheme,
              onChanged: model.changeCustomTheme,
            ),
          )
              : null,
        ));
  }
}