import 'dart:math';

import 'package:chs_connect/app/main/pages/feed/add_photo_post.dart';
import 'package:chs_connect/components/chs_circle_avatar.dart';
import 'package:chs_connect/constants/chs_strings.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:chs_connect/utils/chs_page_transitions.dart';
import 'package:chs_connect/utils/chs_user_cache.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:unicorndial/unicorndial.dart';

class FeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FeedPageState();
  }
}

class _FeedPageState extends State<FeedPage> with TickerProviderStateMixin {
  ChsThemeModel theme;
  ChsUserCache userCache;
  AnimationController animationController;
  ScrollController scrollController;
  int list = 30;
  BuildContext themeContext;


  Widget feedBody(Size size) {
    return Scaffold(
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            appBar(size, boxIsScrolled),
          ];
        },
        body: buildFeed(size),
      ),
      extendBody: true,
      floatingActionButton: fab(size),
    );
  }

  Widget appBar(Size size, bool boxIsScrolled) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      forceElevated: boxIsScrolled,
      title: Text(
        ChsStrings.appName,
        style: theme.theme.textTheme.display1,
      ),
      brightness: theme.theme.appBarTheme.brightness,
      centerTitle: true,
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


            ],
          ),
        )
      ],
      leading: Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(right: size.width * 0.03),),
          GestureDetector(
            onTap: () {},
            child: ChsCircleAvatar(src: userCache.photoUrl,
              radius: size.width * 0.1,
              controller: animationController,),
          ),
        ],
      ),
    );
  }

  Widget buildFeed(Size size) {
    bool white = useWhiteForeground(theme.accentColor);
    return LiquidPullToRefresh(
      onRefresh: () async {
        int rand = Random().nextInt(30);
        setState(() {
          list = rand;
        });
      },
      color: theme.accentColor,
      backgroundColor: white ? Colors.white : Colors.black,
      showChildOpacityTransition: false,
      child: ListView.builder(
        itemCount: list,
        itemBuilder: (context, index) {
          return ListTile(title: Text("Index : $index", style: theme.theme.textTheme.body1,));
        },
      ),
    );
  }

  Widget fab(Size size) {
    var childButtons = List<UnicornButton>();
    fabInit(childButtons);
    return UnicornDialer(
        backgroundColor: theme.darkMode ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.5),
        parentButtonBackground: theme.accentColor,
        orientation: UnicornOrientation.VERTICAL,
        parentButton: Icon(Icons.add, color: theme.lightMode ? Colors.white : theme.iconColor),
        finalButtonIcon: Icon(Icons.clear, color: theme.lightMode ? Colors.white : theme.iconColor),
        childButtons: childButtons);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    theme = Provider.of<ChsThemeModel>(context);
    userCache = Provider.of<ChsUserCache>(context);
    themeContext = context;
    return feedBody(deviceSize);
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 100), lowerBound: 0.0, upperBound: 1.0);
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fabInit(List childButtons) {
    childButtons.add(UnicornButton(
      hasLabel: true,
      labelText: "Video Post",
      labelColor: theme.lightMode ? Colors.white : theme.iconColor,
      labelBackgroundColor: theme.accentColor,
      labelHasShadow: false,
      currentButton: FloatingActionButton(
        backgroundColor: theme.accentColor,
        mini: true,
        heroTag: "Video",
        child: Icon(FeatherIcons.video, color: theme.lightMode ? Colors.white : theme.iconColor,),
        onPressed: () {},
      ),));

    childButtons.add(UnicornButton(
      hasLabel: true,
      labelText: "Photo Post",
      labelColor: theme.lightMode ? Colors.white : theme.iconColor,
      labelBackgroundColor: theme.accentColor,
      labelHasShadow: false,
      currentButton: FloatingActionButton(
        backgroundColor: theme.accentColor,
        mini: true,
        heroTag: "Photo",
        child: Icon(FeatherIcons.image, color: theme.lightMode ? Colors.white : theme.iconColor,),
        onPressed: () {
          Navigator.push(
            themeContext,
            ChsPageRoute.slideUp<void>(
                Provider<ChsThemeModel>.value(
                    value: theme,
                    child: PhotoPostPage()
                )
            ),
          );
        },
      ),));
  }


  bool useWhiteForeground(color) => 1.05 / (color.computeLuminance() + 0.05) > 4.5;

}
