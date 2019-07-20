import 'package:chs_connect/theme/chs_theme.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  ChsThemeModel theme;

  @override
  Widget build(BuildContext context) {
    theme = Provider.of<ChsThemeModel>(context);
    return Scaffold(
      appBar: appBar(),
      body: buildChat(),
      extendBody: true,
    );
  }

  Widget appBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Chat',
        style: theme.theme.textTheme.display1,
      ),
      brightness: theme.theme.appBarTheme.brightness,
    );
  }

  Widget buildChat() {
    return ListView(
      children: MediaQuery
          .of(context)
          .size
          .width >= 480
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
