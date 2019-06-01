import 'package:chs_connect/app/auth/welcome.dart';
import 'package:chs_connect/app/main/pages/feed/feedPage.dart';
import 'package:chs_connect/constants/chs_colors.dart';
import 'package:chs_connect/constants/chs_strings.dart';
import 'package:chs_connect/services/chs_auth.dart';
import 'package:chs_connect/utils/chs_page_transitions.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MainPage extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  const MainPage({Key key, this.analytics, this.observer}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MainPageState(analytics, observer);
  }
}

class _MainPageState extends State<MainPage> {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  FirebaseAuth auth = FirebaseAuth.instance;
  PageController pageController;
  Icon fabIcon;
  int currentIndex;


  _MainPageState(this.analytics, this.observer);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return body(size);
  }

  Future<void> _analyticsSetup() async {
    FirebaseUser user = await auth.currentUser();
    String email = user.email;

    Flushbar(
      message: "You're signed in as $email",
      icon: Icon(Icons.check_circle_outline, color: Colors.green,),
      aroundPadding: EdgeInsets.all(8),
      borderRadius: 8,
      duration: Duration(seconds: 3),
    )..show(context);
    await analytics.setCurrentScreen(
        screenName: 'Main Screen', screenClassOverride: 'MainScreenClass');
  }

  Widget body(Size size) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Container(
            child: FeedPage(),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text('Chat Page!!!'),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text('Status Page!!!'),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text('Account Page!!!'),
                ),
                logOutBtn(size),
              ],
            ),
          )
        ],
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
      ),
      floatingActionButton: _fab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 8,
        fabLocation: BubbleBottomBarFabLocation.end,
        currentIndex: currentIndex,
        hasNotch: true,
        hasInk: true,
        inkColor: Colors.white,
        onTap: _onTap,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: ChsColors.default_blue,
              icon: Icon(CommunityMaterialIcons.home_variant, color: Colors.black,),
              activeIcon: Icon(CommunityMaterialIcons.home_variant, color: ChsColors.default_blue,),
              title: Text(ChsStrings.feedPage)),
          BubbleBottomBarItem(
              backgroundColor: Colors.indigo,
              icon: Icon(CommunityMaterialIcons.chat, color: Colors.black,),
              activeIcon: Icon(CommunityMaterialIcons.chat, color: Colors.indigo,),
              title: Text(ChsStrings.chatPage)),
          BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(CommunityMaterialIcons.hexagon_slice_4, color: Colors.black,),
              activeIcon: Icon(CommunityMaterialIcons.hexagon_slice_4, color: Colors.red,),
              title: Text(ChsStrings.statusPage)),
          BubbleBottomBarItem(
              backgroundColor: Colors.pinkAccent,
              icon: Icon(CommunityMaterialIcons.account_circle, color: Colors.black,),
              activeIcon: Icon(CommunityMaterialIcons.account_circle, color: Colors.pinkAccent,),
              title: Text(ChsStrings.accountPage)),
        ],
      ),

    );
  }

  Widget logOutBtn(Size size) {
    var height = size.height;
    var width = size.width;
    return Container(
      width: width * 0.85,
      margin: EdgeInsets.only(top: height * 0.025),
      padding: EdgeInsets.only(
        top: 5,
        bottom: height * 0.002,
        left: height * 0.015,
        right: height * 0.015,
      ),
      child: FlatButton(
        padding: EdgeInsets.symmetric(vertical: height * 0.02),
        onPressed: () {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return SpinKitWave(
                  color: Colors.white,
                  type: SpinKitWaveType.start,
                );
              }
          );
          FirebaseAuth auth = FirebaseAuth.instance;
          ChsAuth.logOut();
          auth.onAuthStateChanged.listen((FirebaseUser user) async {
            if (user == null) {
              RoutePredicate predicate = (Route<dynamic> route) => false;
              Navigator.pushAndRemoveUntil<void>(context, ChsPageRoute.fadeIn<void>(Welcome(analytics: analytics, observer: observer,)), predicate);
            }
          });
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(height * 0.05)),
            side: BorderSide(
              color: ChsColors.default_blue,
            )),
        child: Text(ChsStrings.log_out,
            style: TextStyle(color: ChsColors.default_blue, fontSize: 17)),
      ),
    );
  }

  _fab() {
    return FloatingActionButton(
      onPressed: () {},
      tooltip: 'Increment',
      child: fabIcon,
      elevation: 2.0,
    );
  }

  _onTap(int position) {
    setState(
          () {
        pageController.jumpToPage(position);
        currentIndex = position;
        switch (position) {
          case 0:
            fabIcon = Icon(Icons.add);
            break;
          case 1:
            fabIcon = Icon(CommunityMaterialIcons.chat);
            break;
          case 2:
            fabIcon = Icon(Icons.add);
            break;
          case 3:
            fabIcon = Icon(Icons.edit);
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _analyticsSetup();
    pageController = PageController();
    fabIcon = Icon(Icons.add);
    currentIndex = 0;

  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }
}