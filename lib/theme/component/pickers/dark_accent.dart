import 'package:chs_connect/theme/component/pickers/dark_picker.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DarkAccentColorPicker extends StatelessWidget {
  const DarkAccentColorPicker({
    this.leading,
    this.label = "Accent Color",
    this.subtitle,
    this.title = const Text("Accent Color"),
    this.showOnlyDarkMode = true,
  });

  final Widget leading, subtitle, title;
  final String label;
  final bool showOnlyDarkMode;

  @override
  Widget build(BuildContext context) {
    return new Consumer<ChsThemeModel>(
        builder: (context, model, child) => Container(
          child: !showOnlyDarkMode ||
              model.darkMode &&
                  showOnlyDarkMode
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
                    child: DarkColorPicker(
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