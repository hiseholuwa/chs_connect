import 'package:chs_connect/app/auth/welcome.dart';
import 'package:chs_connect/app/main/pages/chat/chat.dart';
import 'package:chs_connect/app/main/pages/event/event.dart';
import 'package:chs_connect/app/main/pages/feed/feedPage.dart';
import 'package:chs_connect/constants/chs_strings.dart';
import 'package:chs_connect/services/chs_auth.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:chs_connect/utils/chs_page_transitions.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  ChsThemeModel theme;
  PageController pageController;
  int currentIndex = 0;

  Widget body(Size size) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          children: <Widget>[
            FeedPage(),
            ChatPage(),
            EventPage(),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      'Account Page!!!',
                      style: theme.theme.textTheme.body1,
                    ),
                  ),
                  logOutBtn(size),
                ],
              ),
            )
          ],
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(CommunityMaterialIcons.home_variant_outline), title: Text(ChsStrings.feedsPage)),
          BottomNavigationBarItem(icon: Icon(CommunityMaterialIcons.chat), title: Text(ChsStrings.chatsPage)),
          BottomNavigationBarItem(icon: Icon(CommunityMaterialIcons.ticket), title: Text(ChsStrings.eventsPage)),
          BottomNavigationBarItem(icon: Icon(CommunityMaterialIcons.bell_outline), title: Text(ChsStrings.alertsPage))
        ],
        onTap: _onTap,
        currentIndex: currentIndex,
        selectedItemColor: theme.accentColor,
        selectedLabelStyle: TextStyle(fontFamily: ChsStrings.work_sans),
        unselectedIconTheme: IconThemeData(color: theme.iconColor),
        selectedIconTheme: IconThemeData(color: theme.accentColor),
        elevation: 8,
      ),
      extendBody: true,
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
              });
          FirebaseAuth auth = FirebaseAuth.instance;
          ChsAuth.logOut();
          auth.onAuthStateChanged.listen((FirebaseUser user) async {
            if (user == null) {
              RoutePredicate predicate = (Route<dynamic> route) => false;
              Navigator.pushAndRemoveUntil<void>(
                  context,
                  ChsPageRoute.fadeIn<void>(Welcome()),
                  predicate);
            }
          });
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(height * 0.05)),
            side: BorderSide(
              color: theme.accentColor,
            )),
        child: Text(ChsStrings.log_out,
            style: TextStyle(color: theme.accentColor, fontSize: 17)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    theme = Provider.of<ChsThemeModel>(context);
    Size size = MediaQuery
        .of(context)
        .size;
    return body(size);
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.suspending:
        print("Suspending");
        break;
      case AppLifecycleState.paused:
        print("Paused");
        break;
      case AppLifecycleState.inactive:
        print("Inactive");
        break;
      case AppLifecycleState.resumed:
        statusBarBrightness();
        print("Resumed");
        break;
    }
  }

  _onTap(int index) {
    setState(() {
      currentIndex = index;
      pageController.jumpToPage(index);
    });
  }

  void statusBarBrightness() async {
    Color color = await FlutterStatusbarcolor.getStatusBarColor();
    if (useWhiteForeground(color)) {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
      FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
    } else {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
      FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
    }
  }

  bool useWhiteForeground(color) => 1.05 / (color.computeLuminance() + 0.05) > 4.5;
}