import 'package:chs_connect/theme/component/pickers/picker.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AccentColorPicker extends StatelessWidget {
  const AccentColorPicker({
    this.leading,
    this.label = "Accent Color",
    this.subtitle,
    this.title = const Text("Accent Color"),
    this.showOnlyCustomTheme = true,
  });

  final Widget leading, subtitle, title;
  final String label;
  final bool showOnlyCustomTheme;

  @override
  Widget build(BuildContext context) {
    ChsThemeModel theme = Provider.of<ChsThemeModel>(context);
    Widget title =  Text("Accent Color", style: theme.theme.textTheme.body1,);
    return new Consumer<ChsThemeModel>(
        builder: (context, model, child) => Container(
          child: !showOnlyCustomTheme ||
              (model.customTheme &&
                  showOnlyCustomTheme &&
                  !model.darkMode)
              ? ListTile(
            leading: leading,
            subtitle: subtitle,
            title: title,
            trailing: Container(
              width: 100.0,
              height: 20.0,
              decoration: BoxDecoration(
                  color: model.accentColor,
                  borderRadius: BorderRadius.circular(8.0)),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text(label),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      value: model.accentColor,
                      onChanged: model.changeAccentColor,
                    ),
                  ),
                ),
              );
            },
          )
              : null,
        ));
  }
}