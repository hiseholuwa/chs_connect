import 'package:chs_connect/app/auth/blocs/auth_provider.dart';
import 'package:chs_connect/app/auth/extra.dart';
import 'package:chs_connect/app/auth/verify.dart';
import 'package:chs_connect/app/auth/welcome.dart';
import 'package:chs_connect/app/main/main.dart';
import 'package:chs_connect/constants/chs_colors.dart';
import 'package:chs_connect/constants/chs_images.dart';
import 'package:chs_connect/constants/chs_strings.dart';
import 'package:chs_connect/models/chs_user.dart';
import 'package:chs_connect/services/chs_auth.dart';
import 'package:chs_connect/services/chs_cloud_messaging.dart';
import 'package:chs_connect/services/chs_firestore.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:chs_connect/utils/chs_page_transitions.dart';
import 'package:chs_connect/utils/chs_user_cache.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Splash extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  static ChsThemeModel theme = ChsThemeModel();
  static ChsUserCache userCache;

  Splash({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    userCache = Provider.of<ChsUserCache>(context);
    Future.delayed(Duration(milliseconds: 500), () {
      authState(context);
    });
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: height * 0.18,
          child: Opacity(
            child: Image.asset(ChsImages.auth_logo),
            opacity: 0,
          ),
        ),
      ),
    );
  }

  void resolveTokenConflict(BuildContext context, Size size) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(ChsStrings.auth_alert_title),
            titleTextStyle: TextStyle(color: ChsColors.default_accent, fontFamily: ChsStrings.work_sans, fontSize: 25, fontWeight: FontWeight.w500),
            content: SizedBox(
              height: size.height * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(ChsStrings.auth_alert_text1),
                  Text(ChsStrings.auth_alert_text2),
                  Text(ChsStrings.auth_alert_text3),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(ChsStrings.auth_alert_btn1),
                onPressed: () {
                  ChsAuth.logOut();
                  Future.delayed(Duration(milliseconds: 1000)).then((_) {
                    RoutePredicate predicate = (Route<dynamic> route) => false;
                    Navigator.pushAndRemoveUntil(
                        context,
                        ChsPageRoute.fadeIn<void>(Welcome()),
                        predicate);
                  });
                },
              ),
              FlatButton(
                child: Text(ChsStrings.auth_alert_btn2),
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
                  ChsFirestore.token.updateData(ChsFCM.tokenToMap()).whenComplete(() {
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
                },
              ),
            ],
          );
        }
    );
  }

  Future<void> authState(context) async {
    Size size = MediaQuery
        .of(context)
        .size;
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
    FirebaseUser user = await auth.currentUser();
    bool verified = user?.isEmailVerified;
    if (user != null) {
      Navigator.pop(context);
      ChsAuth.setUser(user);
      Firestore.instance.collection(ChsStrings.database_app_token).document(user.uid).get().then((ts) {
        String token = ChsFCM.token;
        String cloudToken = ChsFCM.getFCMTokenFromDoc(ts);
        if (token != cloudToken) {
          Navigator.pop(context);
          resolveTokenConflict(context, size);
        } else {
          if (userCache.userName.isEmpty) {
            Firestore.instance.collection(ChsStrings.database_app_user).document(user.uid).get().then((ds) {
              if (ds.exists) {
                ChsUser cacheUser = ChsUser.fromDoc(ds);
                userCache.changeUsername(cacheUser.username);
                userCache.changeName(cacheUser.name);
                userCache.changeEmail(cacheUser.email);
                userCache.changePhone(cacheUser.phone);
                userCache.changeBio(cacheUser.bio);
                userCache.changePhotoUrl(cacheUser.photoUrl);
                userCache.changeBirthday(cacheUser.birthday.toUtc().toString());
                if (verified) {
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
                } else {
                  Future.delayed(Duration(milliseconds: 1000)).then((_) {
                    RoutePredicate predicate = (Route<dynamic> route) => false;
                    Navigator.pushAndRemoveUntil(
                        context,
                        ChsPageRoute.fadeIn<void>(
                          Verify(
                            userCache: userCache,
                          ),
                        ),
                        predicate);
                  });
                }
              } else {
                Future.delayed(Duration(milliseconds: 1000)).then((_) {
                  RoutePredicate predicate = (Route<dynamic> route) => false;
                  Navigator.pushAndRemoveUntil(
                      context,
                      ChsPageRoute.fadeIn<void>(
                        AuthProvider(
                            child: ListenableProvider(
                              builder: (_) => userCache..init(),
                              child: Consumer<ChsUserCache>(
                                builder: (context, user, child) {
                                  return ExtraPage();
                                },
                              ),
                            )
                        ),
                      ),
                      predicate);
                });
              }
            });
          } else {
            if (verified) {
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
            } else {
              Future.delayed(Duration(milliseconds: 1000)).then((_) {
                RoutePredicate predicate = (Route<dynamic> route) => false;
                Navigator.pushAndRemoveUntil(
                    context,
                    ChsPageRoute.fadeIn<void>(
                      Verify(
                        userCache: userCache,
                      ),
                    ),
                    predicate);
              });
            }
          }
        }
      });
    } else {
      Future.delayed(Duration(milliseconds: 1000)).then((_) {
        RoutePredicate predicate = (Route<dynamic> route) => false;
        Navigator.pushAndRemoveUntil(
            context,
            ChsPageRoute.fadeIn<void>(Welcome()),
            predicate);
      });
    }
  }
}
