import 'package:chs_connect/constants/chs_strings.dart';
import 'package:chs_connect/theme/component/pickers/dark_picker.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:provider/provider.dart';


class DarkAccentColorPicker extends StatelessWidget {
  const DarkAccentColorPicker({
    this.leading,
    this.label = ChsStrings.accent_color,
    this.subtitle,
    this.showOnlyDarkMode = true,
  });

  final Widget leading, subtitle;
  final String label;
  final bool showOnlyDarkMode;

  @override
  Widget build(BuildContext context) {
    ChsThemeModel theme = Provider.of<ChsThemeModel>(context);
    var height = MediaQuery.of(context).size.height;
    Widget title =  Text(ChsStrings.accent_color, style: theme.theme.textTheme.body1,);
    return new Consumer<ChsThemeModel>(
        builder: (context, model, child) => Container(
          child: !showOnlyDarkMode ||
              model.darkMode &&
                  showOnlyDarkMode
              ? ListTile(
            leading: leading,
            subtitle: subtitle,
            title: title,
            trailing: CircleColor(color: model.darkAccentColor, circleSize: height*0.04,),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text(label),
                  content: DarkColorPicker(
                      value: model.darkAccentColor,
                      onChanged: model.changeDarkAccentColor,
                    ),
                ),
              );
            },
          )
              : null,
        ));
  }
}