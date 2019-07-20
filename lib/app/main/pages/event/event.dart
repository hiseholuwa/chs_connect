import 'package:chs_connect/constants/chs_colors.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:chs_connect/utils/chs_user_cache.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EventPageState();
  }
}

class _EventPageState extends State<EventPage> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  ChsThemeModel theme;
  ChsUserCache userCache;
  TabController tabController;
  ScrollController scrollController;

  _EventPageState();

  Widget body(Size size) {
    return Scaffold(
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            appBar(boxIsScrolled),
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: <Widget>[
            SafeArea(
              top: false,
              bottom: false,
              child: Center(
                child: Text(
                  'This is the All Events tab',
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
            SafeArea(
              top: false,
              bottom: false,
              child: Center(
                child: Text(
                  'This is the Going tab',
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
            SafeArea(
              top: false,
              bottom: false,
              child: Center(
                child: Text(
                  'This is the Hosting tab',
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget appBar(bool boxIsScrolled) {
    return SliverAppBar(
      centerTitle: true,
      pinned: true,
      floating: true,
      forceElevated: boxIsScrolled,
      title: Text(
        'Events',
        style: theme.theme.textTheme.display1,
      ),
      bottom: TabBar(
        controller: tabController,
        tabs: <Tab>[
          Tab(
            child: Text(
              'All Events',
            ),
          ),
          Tab(
            child: Text(
              'Going',
            ),
          ),
          Tab(
            child: Text(
              'Hosting',
            ),
          ),
        ],
      ),
      brightness: theme.theme.appBarTheme.brightness,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Size size = MediaQuery.of(context).size;
    theme = Provider.of<ChsThemeModel>(context);
    userCache = Provider.of<ChsUserCache>(context);
    return body(size);
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3);
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
    scrollController.dispose();
  }

  void snackBar(bool error, String message) {
    if (error) {
      Flushbar(
        message: message,
        icon: Icon(
          Icons.error,
          color: Colors.red,
        ),
        aroundPadding: EdgeInsets.all(8),
        borderRadius: 8,
        backgroundColor: ChsColors.dark_bkg,
        duration: Duration(seconds: 3),
      )..show(context);
    } else {
      Flushbar(
        message: message,
        icon: Icon(
          Icons.check_circle_outline,
          color: Colors.green,
        ),
        aroundPadding: EdgeInsets.all(8),
        borderRadius: 8,
        backgroundColor: ChsColors.dark_bkg,
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
