import 'package:chs_connect/theme/chs_theme.dart';
import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StatusPageState();
  }
}

class _StatusPageState extends State<StatusPage> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
//    final bloc = MainProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Persist Theme',
          style: TextStyle(
              fontFamily: "Rochester",
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 35),
        ),
        elevation: 4,
      ),
      body: buildFeed(deviceSize),
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
          ],
        ),
        DarkAccentColorPicker(),
      ]
          : <Widget>[
        DarkModeSwitch(),
        CustomThemeSwitch(),
        PrimaryColorPicker(),
        AccentColorPicker(),
        DarkAccentColorPicker(),
      ],
    );
  }
}

