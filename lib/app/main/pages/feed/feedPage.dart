import 'package:chs_connect/constants/chs_images.dart';
import 'package:chs_connect/constants/chs_strings.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FeedPageState();
  }
}

class _FeedPageState extends State<FeedPage> {
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
            ChsStrings.appName,
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: deviceSize.height * 0.15,
            child: Image.asset(ChsImages.no_content),
          ),
          SizedBox(
            height: deviceSize.height * 0.02,
          ),
          Text(
            ChsStrings.no_feed,
            style: _theme.theme.textTheme.body1,
          )
        ],
      ),
    );
  }
}
