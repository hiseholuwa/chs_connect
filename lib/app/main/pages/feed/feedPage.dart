import 'package:chs_connect/components/chs_circle_avatar.dart';
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
  AnimationController animationController;
  ScrollController scrollController;
  bool scroll = false;
  bool top = true;

  Widget feedBody(Size size) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: scrollNotification,
        child: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
            return <Widget>[
              appBar(size, boxIsScrolled),
            ];
          },
          body: buildFeed(size),
        ),
      ),
      extendBody: true,
      floatingActionButton: fab(size),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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
                child: ChsCircleAvatar(src: userCache.photoUrl, radius: size.width * 0.1, controller: animationController,),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildFeed(Size size) {
    return ListView.builder(
      itemCount: 30,
      itemBuilder: (context, index) {
        return ListTile(title: Text("Index : $index", style: theme.theme.textTheme.body1,));
      },
    );
  }

  Widget fab(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        top ?
        FloatingActionButton.extended(
          icon: Icon(Icons.add, color: theme.lightMode ? Colors.white : theme.iconColor,),
          label: Text('Add Post', style: TextStyle(color: theme.lightMode ? Colors.white : theme.iconColor,)),
          backgroundColor: theme.accentColor,
          isExtended: top,
          heroTag: 'fab',
          onPressed: () {},
        )
            : FloatingActionButton(
          child: Icon(Icons.add, color: theme.lightMode ? Colors.white : theme.iconColor,),
          backgroundColor: theme.accentColor,
          isExtended: top,
          heroTag: 'fab',
          onPressed: () {},
        ),
        Padding(
          padding: EdgeInsets.only(top: size.height * 0.025),
        ),

      ],
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
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 100), lowerBound: 0.0, upperBound: 1.0);
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.offset <= scrollController.position.minScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        top = true;
      });
    } else {
      setState(() {
        top = false;
      });
    }
  }

  bool scrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (top) {
        setState(() {
          scroll = false;
        });
      } else {
        setState(() {
          scroll = true;
        });
      }
    } else if (notification is ScrollEndNotification) {
      if (top) {
        setState(() {
          scroll = false;
        });
      } else {
        setState(() {
          scroll = true;
        });
      }
    }
  }
}
