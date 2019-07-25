import 'dart:async';

import 'package:chs_connect/app/auth/blocs/auth_provider.dart';
import 'package:chs_connect/app/auth/verify.dart';
import 'package:chs_connect/app/main/main.dart';
import 'package:chs_connect/components/chs_circle_avatar.dart';
import 'package:chs_connect/constants/chs_assets.dart';
import 'package:chs_connect/constants/chs_colors.dart';
import 'package:chs_connect/constants/chs_strings.dart';
import 'package:chs_connect/models/chs_user.dart';
import 'package:chs_connect/services/chs_auth.dart';
import 'package:chs_connect/services/chs_firestore.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:chs_connect/utils/chs_page_transitions.dart';
import 'package:chs_connect/utils/chs_phone.dart';
import 'package:chs_connect/utils/chs_user_cache.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lottie/flutter_lottie.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class ExtraPage extends StatefulWidget {
  const ExtraPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ExtraPageState();
  }
}

class _ExtraPageState extends State<ExtraPage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  final ChsThemeModel theme = ChsThemeModel();
  AnimationController animationController;
  ScrollController scrollController;
  ChsUserCache userCache;
  String name;
  String avatar;
  String prefix = ChsStrings.extra_screen_prefix_init;
  String bd = ChsStrings.extra_screen_bd_init;
  String gradYear = ChsStrings.extra_screen_gy_init;
  DateTime birthday;
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  LottieController controller;

  _ExtraPageState();

  Widget extraScreen(width, height, bloc) {
    return SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Color(0xFFFAFAFA),
            brightness: Brightness.light,
            title: Text(
              ChsStrings.extraScreenAppbarName(name),
              style: TextStyle(color: ChsColors.default_text_high, fontFamily: ChsStrings.rochester, fontSize: 34, fontWeight: FontWeight.w400),
            ),
            elevation: 0,
          ),
          backgroundColor: Color(0xFFFAFAFA),
          body: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(height * 0.02),
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(width * 0.02),
                        ),
                        Container(
                          height: height * 0.08,
                          width: height * 0.08,
                          child: ChsCircleAvatar(
                            src: userCache.photoUrl,
                            radius: height * 0.08,
                            controller: animationController,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(width * 0.02),
                        ),
                        Text(ChsStrings.extra_screen_username,
                          style: TextStyle(color: Colors.black),),
                        Padding(
                          padding: EdgeInsets.all(width * 0.02),
                        ),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: width * 0.52,
                          ),
                          child: StreamBuilder(
                              stream: bloc.username,
                              builder: (context, snapshot) {
                                return TextField(
                                  style: new TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                  ),
                                  keyboardType: TextInputType.text,
                                  onChanged: bloc.changeUserName,
                                  decoration: InputDecoration(
                                    hintText: ChsStrings.extra_screen_username_hint,
                                    hintStyle: TextStyle(color: Colors.black54),
                                    contentPadding: EdgeInsets.fromLTRB(height * 0.025, height * 0.010, height * 0.025, height * 0.010),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(height * 0.05),
                                    ),
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                    errorText: snapshot.error,
                                  ),
                                  cursorColor: ChsColors.default_accent,
                                  controller: usernameController,
                                );
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            right: ((width * 0.04)),
                            top: height * 0.08,
                          ),
                        ),
                        Text(ChsStrings.extra_screen_phone,
                            style: TextStyle(color: Colors.black)),
                        Padding(
                          padding: EdgeInsets.all(width * 0.02),
                        ),
                        CountryPickerDropdown(
                          initialValue: ChsStrings.extra_screen_phone_init,
                          itemBuilder: _buildDropdownItem,
                          onValuePicked: (Country country) {
                            setState(() {
                              prefix = country.phoneCode;
                            });
                          },
                        ),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: width * 0.65,
                          ),
                          child: Row(
                            children: <Widget>[
                              Text(
                                '+' + prefix,
                                style: TextStyle(color: ChsColors.default_accent, fontSize: 16),
                              ),
                              Padding(
                                padding: EdgeInsets.all(width * 0.01),
                              ),
                              Container(
                                  constraints: BoxConstraints(maxWidth: width * 0.45),
                                  child: StreamBuilder(
                                      stream: bloc.phone,
                                      builder: (context, snapshot) {
                                        return TextField(
                                          style: new TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                          ),
                                          keyboardType: TextInputType.phone,
                                          onChanged: bloc.changePhone,
                                          decoration: InputDecoration(
                                            hintText: ChsStrings.extra_screen_phone_hint,
                                            hintStyle: TextStyle(
                                                color: Colors.black54),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.circular(height * 0.05),
                                            ),
                                            contentPadding: EdgeInsets.fromLTRB(height * 0.01, height * 0.025, height * 0.025, 0),
                                            fillColor: Colors.grey[200],
                                            filled: true,
                                            errorText: snapshot.error,
                                          ),
                                          cursorColor: ChsColors.default_accent,
                                          controller: phoneController,
                                          inputFormatters: [ChsPhone()],
                                        );
                                      }))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            right: ((width * 0.04)),
                            top: height * 0.08,
                          ),
                        ),
                        Text(ChsStrings.extra_screen_bd,
                            style: TextStyle(color: Colors.black)),
                        Padding(
                          padding: EdgeInsets.all(width * 0.02),
                        ),
                        GestureDetector(
                          onTap: () async {
                            DateTime date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(9999),
                              builder: (BuildContext context, Widget child) {
                                return Theme(
                                  data: ThemeData(
                                    primaryColor: ChsColors.default_accent,
                                  ),
                                  child: child,
                                );
                              },
                            );
                            setState(() {
                              if (date != null) {
                                birthday = date;
                                bd = month(date.month) + ' ' + date.day.toString();
                              }
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            constraints: BoxConstraints(
                              maxWidth: width * 0.3,
                              minHeight: height * 0.05,
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(width: 0, color: Colors.grey[200]), shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(height * 0.05), color: Colors.grey[200]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  bd,
                                  style: TextStyle(color: ChsColors.default_accent, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            right: ((width * 0.04)),
                            top: height * 0.08,
                          ),
                        ),
                        Text(ChsStrings.extra_screen_bio,
                            style: TextStyle(color: Colors.black)),
                        Padding(
                          padding: EdgeInsets.all(width * 0.02),
                        ),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: width * 0.8,
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                constraints: BoxConstraints(maxWidth: width * 0.75),
                                child: StreamBuilder(
                                    stream: bloc.bio,
                                    builder: (context, snapshot) {
                                      return TextField(
                                        style: new TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                        ),
                                        keyboardType: TextInputType.multiline,
                                        onChanged: bloc.changeBio,
                                        decoration: InputDecoration(
                                          hintText: ChsStrings.extra_screen_bio_hint,
                                          hintStyle: TextStyle(
                                              color: Colors.black54),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.circular(height * 0.05),
                                          ),
                                          contentPadding: EdgeInsets.fromLTRB(height * 0.01, height * 0.025, height * 0.025, 0),
                                          fillColor: Colors.grey[200],
                                          filled: true,
                                          errorText: snapshot.error,
                                        ),
                                        cursorColor: ChsColors.default_accent,
                                        controller: bioController,
                                      );
                                    }),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            right: ((width * 0.04)),
                            top: height * 0.08,
                          ),
                        ),
                        Text(ChsStrings.extra_screen_gy,
                            style: TextStyle(color: Colors.black)),
                        Padding(
                          padding: EdgeInsets.all(width * 0.02),
                        ),
                        GestureDetector(
                          onTap: () async {
                            DateTime date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(9999),
                              builder: (BuildContext context, Widget child) {
                                return Theme(
                                  data: ThemeData(
                                    primaryColor: ChsColors.default_accent,
                                  ),
                                  child: child,
                                );
                              },
                            );
                            setState(() {
                              if (date != null) {
                                gradYear = date.year.toString();
                              }
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            constraints: BoxConstraints(
                              maxWidth: width * 0.3,
                              minHeight: height * 0.05,
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(width: 0, color: Colors.grey[200]), shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(height * 0.05), color: Colors.grey[200]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  gradYear,
                                  style: TextStyle(color: ChsColors.default_accent, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: width,
                  height: height * 0.5,
                  child: LottieView.fromFile(
                    loop: true,
                    filePath: ChsAssets.dino_anim,
                    autoPlay: true,
                    onViewCreated: onViewCreatedFile,
                  ),
                ),
                Center(
                  child: Text(
                    ChsStrings.extra_screen_text,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: new BottomAppBar(
            color: ChsColors.default_accent,
            child: Container(
              height: height * 0.06,
              child: StreamBuilder(
                  stream: bloc.extraContinue,
                  builder: (context, snapshot) {
                    return GestureDetector(
                      onTap: () {
                        if (snapshot.hasData) {
                          updateProfile();
                        } else {
                          snackBar(true, ChsStrings.snackbar_chk_extra_err);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            ChsStrings.extra_screen_continue,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ),
    );
  }

  Widget _buildDropdownItem(Country country) => Container(
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    changeStatusBar();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final bloc = AuthProvider.of(context);
    userCache = Provider.of<ChsUserCache>(context);
    name = userCache.name.split(" ")[0];
    return extraScreen(width, height, bloc);
  }

  @override
  void initState() {
    super.initState();
    _analyticsSetup();
    changeStatusBar();
    usernameController = TextEditingController();
    phoneController = TextEditingController();
    bioController = TextEditingController();
    scrollController = ScrollController();
    animationController = AnimationController(vsync: this, duration: Duration(seconds: 3), lowerBound: 0.0, upperBound: 1.0);
    WidgetsBinding.instance.addObserver(this);

  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.suspending:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        changeStatusBar();
        break;
    }
  }

  Future<void> _analyticsSetup() async {
    await analytics.setCurrentScreen(screenName: 'Extra Screen', screenClassOverride: 'ExtraScreenClass');
  }

  void changeStatusBar() async {
    await FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    await FlutterStatusbarcolor.setNavigationBarColor(Colors.white);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
  }

  void onViewCreatedFile(LottieController controller) {
    this.controller = controller;
  }

  String phoneNumber() {
    RegExp digitOnlyRegex = RegExp(r'\d+');
    List reg = digitOnlyRegex.allMatches(phoneController.value.text).map((m) => m.group(0).toString()).toList();
    String fin = reg.join();
    String num = '+' + prefix + fin;
    return num;
  }

  String month(int month) {
    switch (month) {
      case 1:
        return ChsStrings.january;
      case 2:
        return ChsStrings.february;
      case 3:
        return ChsStrings.march;
      case 4:
        return ChsStrings.april;
      case 5:
        return ChsStrings.may;
      case 6:
        return ChsStrings.june;
      case 7:
        return ChsStrings.july;
      case 8:
        return ChsStrings.august;
      case 9:
        return ChsStrings.september;
      case 10:
        return ChsStrings.october;
      case 11:
        return ChsStrings.november;
      case 12:
        return ChsStrings.december;
      default:
        return null;
    }
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

  void updateProfile() async {
    String userName = usernameController.value.text;
    String bio = bioController.value.text;
    String phone = phoneNumber();
    FirebaseUser authUser = await FirebaseAuth.instance.currentUser();

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return SpinKitWave(
            color: Colors.white,
            type: SpinKitWaveType.start,
          );
        });

    try {
      Firestore.instance.collection(ChsStrings.database_app_username).document(userName).get().then((ds) {
        if (ds.exists) {
          Navigator.pop(context);
          snackBar(true, ChsStrings.extra_screen_username_snackbar);
        } else {
          ChsUser user = ChsUser(
            username: userName,
            name: userCache.name,
            email: authUser.email,
            phone: phone,
            bio: bio,
            posts: 0,
            followers: 0,
            following: 0,
            photoUrl: userCache.photoUrl,
            birthday: birthday ?? DateTime.now().toUtc(),
            gradYear: gradYear ?? DateTime.now().toUtc(),
            private: false,
            createdAt: Timestamp.fromMillisecondsSinceEpoch(authUser.metadata.creationTimestamp),
          );
          userCache.changeUsername(userName);
          userCache.changeEmail(authUser.email);
          userCache.changePhone(phone);
          userCache.changeBio(bio);
          userCache.changeBirthday(birthday.toUtc().toString());
          userCache.changeGradYear(gradYear);
          userCache.changePosts(0);
          userCache.changeFollowers(0);
          userCache.changeFollowing(0);
          userCache.changePrivate(false);
          ChsFirestore.userName(userName).setData(ChsFirestore.idToMap(authUser.uid));
          ChsAuth.setUser(authUser);

          if (!authUser.isEmailVerified) {
            ChsAuth.verifyEmail();
            ChsFirestore.user.setData(user.toMap()).whenComplete(() {
              RoutePredicate predicate = (Route<dynamic> route) => false;
              Navigator.pushAndRemoveUntil(
                  context,
                  ChsPageRoute.fadeIn<void>(Verify(
                    userCache: userCache,
                  )),
                  predicate);
            });
          } else {
            ChsFirestore.user.setData(user.toMap()).whenComplete(() {
              RoutePredicate predicate = (Route<dynamic> route) => false;
              Navigator.pushAndRemoveUntil(
                  context,
                  ChsPageRoute.slideIn<void>(ListenableProvider(
                    builder: (_) => theme..init(),
                    child: Consumer<ChsThemeModel>(
                      builder: (context, model, child) {
                        return Theme(
                          data: model.theme,
                          child: MainPage(),
                        );
                      },
                    ),
                  )),
                  predicate);
            });
          }
        }
      });
    } on PlatformException catch (e) {
      if (e.message != null) {
        Navigator.pop(context);
        snackBar(true, e.message);
      }
    }
  }
}
