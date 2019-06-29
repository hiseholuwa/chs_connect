import 'dart:async';

import 'package:chs_connect/app/auth/blocs/auth_provider.dart';
import 'package:chs_connect/app/auth/verify.dart';
import 'package:chs_connect/components/chs_circle_avatar.dart';
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

class ExtraPage extends StatefulWidget {
  const ExtraPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ExtraPageState();
  }
}

class _ExtraPageState extends State<ExtraPage> with SingleTickerProviderStateMixin {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  AnimationController _controller;
  ChsThemeModel theme;
  ChsUserCache userCache;
  String name;
  String avatar;
  String prefix = '234';
  String bd = 'May 28';
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
            backgroundColor: theme.theme.appBarTheme.color,
            title: Text(
              "Hi $name",
              style: theme.theme.textTheme.display1,
            ),
            elevation: theme.theme.appBarTheme.elevation,
          ),
          backgroundColor: ChsColors.default_scaffold,
          body: Column(
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
                          controller: _controller,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(width * 0.02),
                      ),
                      Text("Username:"),
                      Padding(
                        padding: EdgeInsets.all(width * 0.02),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: width * 0.45,
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
                                  hintText: "Username...",
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
                      Text("Phone:"),
                      Padding(
                        padding: EdgeInsets.all(width * 0.02),
                      ),
                      CountryPickerDropdown(
                        initialValue: 'ng',
                        itemBuilder: _buildDropdownItem,
                        onValuePicked: (Country country) {
                          setState(() {
                            prefix = country.phoneCode;
                          });
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(width * 0.02),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: width * 0.55,
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
                                constraints: BoxConstraints(maxWidth: width * 0.42),
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
                                          hintText: "(123)-456-7890",
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
                      Text("Birthday:"),
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
                                  primaryColor: theme.theme.accentColor,
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
                      Text("Bio:"),
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
                                        hintText: "Y'ello",
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
              SizedBox(
                width: width,
                height: height * 0.4,
                child: LottieView.fromFile(
                  loop: true,
                  filePath: "assets/animations/dino-dance.json",
                  autoPlay: true,
                  onViewCreated: onViewCreatedFile,
                ),
              ),
              Center(
                child: Text(
                  "Almost there.... 😎",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ],
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
                            "Continue",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ));
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final bloc = AuthProvider.of(context);
    theme = Provider.of<ChsThemeModel>(context);
    userCache = Provider.of<ChsUserCache>(context);
    name = userCache.name.split(" ")[0];
    return extraScreen(width, height, bloc);
  }

  @override
  void initState() {
    super.initState();
    _analyticsSetup();
    usernameController = TextEditingController();
    phoneController = TextEditingController();
    bioController = TextEditingController();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 3), lowerBound: 0.0, upperBound: 1.0);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _analyticsSetup() async {
    await analytics.setCurrentScreen(screenName: 'Extra Screen', screenClassOverride: 'ExtraScreenClass');
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
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
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

  void updateProfile() {
    String userName = usernameController.value.text;
    String bio = bioController.value.text;
    String phone = phoneNumber();
    FirebaseUser authUser = ChsAuth.getUser;
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
      bool exist = false;
      Firestore.instance.collection('user').where("username", isEqualTo: userName).snapshots().listen((data) => data.documents.isEmpty ? exist = false : exist = true);
      if (exist) {
        snackBar(true, "Username exists already 😭! Choose another.");
      } else {
        ChsUser user = ChsUser(
          username: userName,
          name: userCache.name,
          email: authUser.email,
          phone: phone,
          bio: bio,
          photoUrl: userCache.photoUrl,
          birthday: birthday ?? DateTime.now().toUtc(),
          createdAt: Timestamp.fromMillisecondsSinceEpoch(authUser.metadata.creationTimestamp),
        );

        ChsFirestore.userName(userName).setData({'id': authUser.uid});
        ChsAuth.verifyEmail();
        ChsFirestore.user.setData(user.toMap()).whenComplete(() {
          RoutePredicate predicate = (Route<dynamic> route) => false;
          Navigator.pushAndRemoveUntil(
              context,
              ChsPageRoute.slideIn<void>(Verify(
                userCache: userCache,
              )),
              predicate);
        });
      }
    } on PlatformException catch (e) {
      if (e.message != null) {
        Navigator.pop(context);
        snackBar(true, e.message);
      }
    }
  }
}
