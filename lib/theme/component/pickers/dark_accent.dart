import 'package:chs_connect/constants/chs_strings.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/material_picker.dart';
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
    Widget title = Text(
      ChsStrings.accent_color,
      style: theme.theme.textTheme.body1,
    );
    Widget ok = Text(
      "OK",
      style: TextStyle(color: theme.theme.accentColor),
    );
    return new Consumer<ChsThemeModel>(
        builder: (context, model, child) => Container(
              child: !showOnlyDarkMode || model.darkMode && showOnlyDarkMode
                  ? ListTile(
                      leading: leading,
                      subtitle: subtitle,
                      title: title,
                      trailing: Material(
                        elevation: 4,
                        shape: const CircleBorder(),
                        child: CircleAvatar(
                          backgroundColor: model.darkAccentColor,
                          radius: height * 0.02,
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: Text(label),
                                content: MaterialPicker(
                                  pickerColor: model.darkAccentColor,
                                  onColorChanged: model.changeDarkAccentColor,
                                  enableLabel: true,
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: ok,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                        );
                      },
                    )
                  : null,
            ));
  }
}
