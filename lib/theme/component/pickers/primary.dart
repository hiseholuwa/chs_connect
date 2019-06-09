import 'package:chs_connect/constants/chs_strings.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/material_picker.dart';
import 'package:provider/provider.dart';

class PrimaryColorPicker extends StatelessWidget {
  const PrimaryColorPicker({
    this.leading,
    this.subtitle,
    this.label = ChsStrings.primary_color,
    this.showOnlyCustomTheme = true,
  });

  final Widget leading, subtitle;
  final String label;
  final bool showOnlyCustomTheme;

  @override
  Widget build(BuildContext context) {
    ChsThemeModel theme = Provider.of<ChsThemeModel>(context);
    var height = MediaQuery.of(context).size.height;
    Widget title = Text(
      ChsStrings.primary_color,
      style: theme.theme.textTheme.body1,
    );
    Widget ok = Text(
      "OK",
      style: TextStyle(color: theme.theme.accentColor),
    );

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
                      trailing: Material(
                        elevation: 4,
                        shape: const CircleBorder(),
                        child: CircleAvatar(
                          backgroundColor: model.primaryColor,
                          radius: height * 0.02,
                        ),
                      ),
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: Text(label),
                                content: MaterialPicker(
                                  pickerColor: model.primaryColor,
                                  onColorChanged: model.changePrimaryColor,
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
