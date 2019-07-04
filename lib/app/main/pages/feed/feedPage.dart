import 'package:chs_connect/components/chs_circle_avatar.dart';
import 'package:chs_connect/constants/chs_images.dart';
import 'package:chs_connect/constants/chs_strings.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:chs_connect/utils/chs_user_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FeedPageState();
  }
}

class _FeedPageState extends State<FeedPage> with TickerProviderStateMixin {
  ChsThemeModel theme;
  ChsUserCache userCache;
  AnimationController controller;

  Widget feedBody(Size size) {
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: appBar(size),
        body: buildFeed(size),
        extendBody: true,
      ),
    );
  }

  Widget appBar(Size size) {
    return AppBar(
      backgroundColor: theme.theme.appBarTheme.color,
      title: Text(
        ChsStrings.appName,
        style: theme.theme.textTheme.display1,
      ),
      elevation: theme.theme.appBarTheme.elevation,
      brightness: theme.theme.appBarTheme.brightness,
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: size.width * 0.05),
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {

                },
                child: Icon(Icons.person_add),
              ),
              Padding(padding: EdgeInsets.only(right: size.width * 0.05),),
              GestureDetector(
                onTap: () {},
                child: ChsCircleAvatar(src: userCache.photoUrl, radius: size.width * 0.1, controller: controller,),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildFeed(Size size) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: size.height * 0.15,
            child: Image.asset(ChsImages.no_content),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Text(
            ChsStrings.no_feed,
            style: theme.theme.textTheme.body1,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    theme = Provider.of<ChsThemeModel>(context);
    userCache = Provider.of<ChsUserCache>(context);
    return feedBody(deviceSize);
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 100), lowerBound: 0.0, upperBound: 1.0);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
