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
  ChsThemeModel theme;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    theme = Provider.of<ChsThemeModel>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.theme.appBarTheme.color,
          title: Text(
            ChsStrings.appName,
            style: theme.theme.textTheme.display1,
          ),
          elevation: theme.theme.appBarTheme.elevation,
          brightness: theme.theme.appBarTheme.brightness,
        ),
        body: buildFeed(deviceSize),
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
            style: theme.theme.textTheme.body1,
          )
        ],
      ),
    );
  }
}
