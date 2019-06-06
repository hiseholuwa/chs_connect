import 'package:chs_connect/theme/chs_theme.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StatusPageState();
  }
}

class _StatusPageState extends State<StatusPage> {
  ChsThemeModel _theme;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    _theme = Provider.of<ChsThemeModel>(context);
//    final bloc = MainProvider.of(context);
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: _theme.theme.appBarTheme.color,
          title: Text(
            'Change Theme',
            style: _theme.theme.textTheme.display1,
          ),
          elevation: _theme.theme.appBarTheme.elevation,
          brightness: _theme.theme.appBarTheme.brightness,
        ),
        body: buildFeed(deviceSize),
      ),
    );
  }

  Widget buildFeed(Size deviceSize) {
    return ListView(
      children: MediaQuery.of(context).size.width >= 480
          ? <Widget>[
        Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Flexible(child: DarkModeSwitch()),
          ],
        ),
        CustomThemeSwitch(),
        Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Flexible(child: PrimaryColorPicker()),
            Flexible(child: AccentColorPicker()),
            Flexible(child: ScaffoldColorPicker()),
            Flexible(child: BackgroundColorPicker()),
            Flexible(child: TextHighColorPicker()),
            Flexible(child: TextMediumColorPicker()),
            Flexible(child: TextDisabledColorPicker()),
            Flexible(child: IconColorPicker()),
          ],
        ),
        DarkAccentColorPicker(),
      ]
          : <Widget>[
        DarkModeSwitch(),
        CustomThemeSwitch(),
        PrimaryColorPicker(),
        AccentColorPicker(),
        ScaffoldColorPicker(),
        BackgroundColorPicker(),
        TextHighColorPicker(),
        TextMediumColorPicker(),
        TextDisabledColorPicker(),
        IconColorPicker(),
        DarkAccentColorPicker(),
      ],
    );
  }
}

