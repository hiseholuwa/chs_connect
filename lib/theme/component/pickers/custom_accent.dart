import 'package:chs_connect/constants/chs_strings.dart';
import 'package:chs_connect/theme/component/pickers/picker.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:provider/provider.dart';


class AccentColorPicker extends StatelessWidget {
  const AccentColorPicker({
    this.leading,
    this.label = ChsStrings.accent_color,
    this.subtitle,
    this.showOnlyCustomTheme = true,
  });

  final Widget leading, subtitle;
  final String label;
  final bool showOnlyCustomTheme;

  @override
  Widget build(BuildContext context) {
    ChsThemeModel theme = Provider.of<ChsThemeModel>(context);
    var height = MediaQuery.of(context).size.height;
    Widget title =  Text(ChsStrings.accent_color, style: theme.theme.textTheme.body1,);
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
            trailing: CircleColor(color: model.accentColor, circleSize: height*0.04,),
            onTap: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text(label),
                  content: ColorPicker(
                      value: model.accentColor,
                      onChanged: model.changeAccentColor,
                    ),
                  ),
              );
            },
          )
              : null,
        ));
  }
}