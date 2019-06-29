import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:chs_connect/app/auth/welcome.dart';
import 'package:chs_connect/app/main/pages/chat/chat.dart';
import 'package:chs_connect/app/main/pages/feed/feedPage.dart';
import 'package:chs_connect/app/main/pages/status/status.dart';
import 'package:chs_connect/constants/chs_colors.dart';
import 'package:chs_connect/constants/chs_constants.dart';
import 'package:chs_connect/constants/chs_strings.dart';
import 'package:chs_connect/services/chs_auth.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:chs_connect/utils/chs_page_transitions.dart';
import 'package:chs_connect/utils/chs_preferences.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MainPage extends StatefulWidget {

  const MainPage({Key key}) : super(key: key);

  static _MainPageState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<MainPage>());

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  ChsThemeModel theme;
  PageController pageController;
  Icon fabIcon;
  int currentIndex;

  _MainPageState();

  Widget body(Size size) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        body: PageView(
          children: <Widget>[
            Container(
              child: FeedPage(),
            ),
            Container(
              child: ChatPage(),
            ),
            Container(
              child: StatusPage(),
            ),
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
        floatingActionButton: _fab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BubbleBottomBar(
          opacity: .2,
          backgroundColor: theme.theme.primaryColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          elevation: 6,
          fabLocation: BubbleBottomBarFabLocation.end,
          currentIndex: currentIndex,
          hasNotch: true,
          hasInk: true,
          onTap: _onTap,
          items: <BubbleBottomBarItem>[
            BubbleBottomBarItem(
                backgroundColor: theme.accentColor,
                icon: Icon(
                  CommunityMaterialIcons.home_variant,
                  color: theme.iconColor,
                ),
                activeIcon: Icon(
                  CommunityMaterialIcons.home_variant,
                  color: theme.accentColor,
                ),
                title: Text(ChsStrings.feedPage)),
            BubbleBottomBarItem(
                backgroundColor: theme.accentColor,
                icon: Icon(
                  CommunityMaterialIcons.chat,
                  color: theme.iconColor,
                ),
                activeIcon: Icon(
                  CommunityMaterialIcons.chat,
                  color: theme.accentColor,
                ),
                title: Text(ChsStrings.chatPage)),
            BubbleBottomBarItem(
                backgroundColor: theme.accentColor,
                icon: Icon(
                  CommunityMaterialIcons.hexagon_slice_4,
                  color: theme.iconColor,
                ),
                activeIcon: Icon(
                  CommunityMaterialIcons.hexagon_slice_4,
                  color: theme.accentColor,
                ),
                title: Text(ChsStrings.statusPage)),
            BubbleBottomBarItem(
                backgroundColor: theme.accentColor,
                icon: Icon(
                  CommunityMaterialIcons.account_circle,
                  color: theme.iconColor,
                ),
                activeIcon: Icon(
                  CommunityMaterialIcons.account_circle,
                  color: theme.accentColor,
                ),
                title: Text(ChsStrings.accountPage)),
          ],
        ),
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
    var size = MediaQuery
        .of(context)
        .size;
    theme = Provider.of<ChsThemeModel>(context);
    return body(size);
  }

  @override
  void initState() {
    super.initState();
    _analyticsSetup();
    pageController = PageController();
    currentIndex = 0;
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  Future<void> _analyticsSetup() async {
    FirebaseUser user = ChsAuth.getUser;
    String email = user.email;
    bool newUser = await ChsPreferences.getBool(IS_FIRST_TIME_LOGIN);
    if (true) {
      ChsPreferences.setBool(IS_FIRST_TIME_LOGIN, false);
      await analytics.logEvent(
        name: 'new_user',
        parameters: <String, dynamic>{
          'id': user.uid,
          'name': user.displayName,
          'email': user.email,
        },
      );
      Flushbar(
        message: "Welcome 😃! \nYou're signed in as $email",
        icon: Icon(
          Icons.check_circle_outline,
          color: Colors.green,
        ),
        aroundPadding: EdgeInsets.all(8),
        borderRadius: 8,
        backgroundColor: theme.darkMode ? Colors.white : ChsColors.dark_bkg,
        duration: Duration(seconds: 3),
      )
        ..show(context);
    }


    await analytics.setCurrentScreen(
        screenName: 'Main Screen', screenClassOverride: 'MainScreenClass');
  }

  _fab() {
    switch (currentIndex) {
      case 0:
        fabIcon = Icon(
          Icons.add,
          color: theme.lightMode ? Colors.white : theme.iconColor,
        );
        break;
      case 1:
        fabIcon = Icon(
          CommunityMaterialIcons.chat,
          color: theme.lightMode ? Colors.white : theme.iconColor,
        );
        break;
      case 2:
        fabIcon = Icon(
          Icons.add,
          color: theme.lightMode ? Colors.white : theme.iconColor,
        );
        break;
      case 3:
        fabIcon = Icon(
          Icons.edit,
          color: theme.lightMode ? Colors.white : theme.iconColor,
        );
    }
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: theme.accentColor,
      child: fabIcon,
      elevation: 2.0,
    );
  }

  _onTap(int position) {
    setState(
          () {
        pageController.jumpToPage(position);
        currentIndex = position;
      },
    );
  }

}
