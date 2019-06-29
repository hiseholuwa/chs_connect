import 'dart:io';
import 'dart:typed_data';

import 'package:chs_connect/app/auth/blocs/auth_provider.dart';
import 'package:chs_connect/app/auth/extra.dart';
import 'package:chs_connect/app/auth/tools/card_clipper.dart';
import 'package:chs_connect/constants/chs_colors.dart';
import 'package:chs_connect/constants/chs_constants.dart';
import 'package:chs_connect/constants/chs_strings.dart';
import 'package:chs_connect/services/chs_auth.dart';
import 'package:chs_connect/services/chs_cloud_messaging.dart';
import 'package:chs_connect/services/chs_cloud_storage.dart';
import 'package:chs_connect/services/chs_firestore.dart';
import 'package:chs_connect/utils/chs_page_transitions.dart';
import 'package:chs_connect/utils/chs_preferences.dart';
import 'package:chs_connect/utils/chs_user_cache.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class RegisterCard extends StatefulWidget {

  RegisterCard({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegisterCardState();
  }
}

class _RegisterCardState extends State<RegisterCard> with TickerProviderStateMixin {
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  _RegisterCardState();

  var height;
  var width;
  ChsUserCache userCache;
  AnimationController controller;
  AnimationController photoController;
  Animation<double> animation;
  TextEditingController userNameController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<Asset> images = List<Asset>();
  List<int> finalImage;
  var uuid = Uuid();

  Widget registerCard(AuthBloc bloc) {
    return Container(
      margin: EdgeInsets.only(top: height / 10),
      child: Opacity(
        opacity: animation.value,
        child: SizedBox(
            width: width * 0.85,
            child: Column(
              children: <Widget>[
                Center(
                  child: GestureDetector(
                      onTap: () {
                        loadImages();
                      },
                      child: images.isEmpty
                          ? CircleAvatar(
                          backgroundColor: ChsColors.default_accent,
                          radius: height * 0.1,
                          child: Icon(
                            Icons.add_a_photo,
                            size: height * 0.1,
                            color: Colors.white,
                          ))
                          : avatar()),
                ),
                ClipPath(
                  clipper: CardClipper(),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Card(
                    color: Colors.white,
                    elevation: 1.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: registerBuilder(bloc),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget registerBuilder(AuthBloc bloc) {
    return Form(
      child: Padding(
        padding: EdgeInsets.only(
          left: height * 0.03,
          right: height * 0.03,
          bottom: height * 0.03,
          top: height * 0.05,
        ),
        child: new Column(
          children: <Widget>[
            fullNameField(bloc),
            SizedBox(
              height: height * 0.02,
            ),
            emailField(bloc),
            SizedBox(
              height: height * 0.02,
            ),
            passwordField(bloc),
            SizedBox(
              height: height * 0.025,
            ),
            submitBtn(bloc),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(ChsStrings.sign_in, style: TextStyle(color: ChsColors.default_accent, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget fullNameField(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.fullName,
      builder: (context, snapshot) {
        return TextField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          controller: fullNameController,
          onChanged: bloc.changeFullName,
          style: new TextStyle(
            fontSize: 17.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: ChsStrings.enter_full_name_hint,
            contentPadding: EdgeInsets.fromLTRB(height * 0.025, height * 0.012, height * 0.025, height * 0.012),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(height * 0.1),
            ),
            errorText: snapshot.error,
            filled: true,
            fillColor: Color(0xffeeeeee),
            hintStyle: TextStyle(color: Colors.black38),
            prefixIcon: Icon(
              Icons.person,
              color: ChsColors.default_accent,
            ),
          ),
        );
      },
    );
  }

  Widget emailField(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot) {
        return TextField(
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          controller: emailController,
          onChanged: bloc.changeEmail,
          style: new TextStyle(
            fontSize: 17.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: ChsStrings.enter_email_hint,
            contentPadding: EdgeInsets.fromLTRB(height * 0.025, height * 0.012, height * 0.025, height * 0.012),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(height * 0.1),
            ),
            filled: true,
            fillColor: Color(0xffeeeeee),
            prefixIcon: Icon(
              Icons.email,
              color: ChsColors.default_accent,
            ),
            hintStyle: TextStyle(color: Colors.black38),
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget passwordField(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.password,
      builder: (context, snapshot) {
        return TextField(
          style: new TextStyle(
            fontSize: 17.0,
            color: Colors.black,
          ),
          textInputAction: TextInputAction.done,
          controller: passwordController,
          onChanged: bloc.changePassword,
          obscureText: true,
          decoration: InputDecoration(
            hintText: ChsStrings.enter_password_hint,
            contentPadding: EdgeInsets.fromLTRB(height * 0.025, height * 0.012, height * 0.025, height * 0.012),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(height * 0.1),
            ),
            errorText: snapshot.error,
            filled: true,
            fillColor: Color(0xffeeeeee),
            prefixIcon: Icon(
              Icons.lock,
              color: ChsColors.default_accent,
            ),
            hintStyle: TextStyle(color: Colors.black38),
          ),
        );
      },
    );
  }

  Widget submitBtn(AuthBloc bloc) {
    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: height * 0.015,
            right: height * 0.015,
          ),
          child: RaisedButton(
            padding: EdgeInsets.symmetric(vertical: height * 0.02),
            color: ChsColors.default_accent,
            disabledColor: Colors.grey[200],
            onPressed: snapshot.hasData
                ? () {
              register();
            }
                : null,
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(height * 0.05))),
            child: Text(ChsStrings.create, style: TextStyle(color: Colors.white, fontSize: 17)),
          ),
        );
      },
    );
  }

  Widget avatar() {
    photoController.forward();
    return FadeTransition(
        opacity: photoController,
        child: Container(
          height: height * 0.2,
          width: height * 0.2,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: MemoryImage(Uint8List.fromList(finalImage)),
              )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery
        .of(context)
        .size
        .height;
    width = MediaQuery
        .of(context)
        .size
        .width;
    final bloc = AuthProvider.of(context);
    userCache = Provider.of<ChsUserCache>(context);
    return registerCard(bloc);
  }

  @override
  void initState() {
    super.initState();
    setupControllers();
  }

  @override
  void dispose() {
    controller.dispose();
    photoController.dispose();
    super.dispose();
  }

  void setupControllers() {
    controller = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 1500),
    );
    animation = new Tween(begin: 0.0, end: 1.0).animate(
      new CurvedAnimation(
        parent: controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation.addListener(() => this.setState(() {}));
    controller.forward();
    photoController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
  }

  Future<void> loadImages() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    List<int> tempImage;
    ByteData tempByte;
    File tempFile;
    File croppedFile;
    String error;
    String name;

    Directory tempDir = await getTemporaryDirectory();
    String path = tempDir.path;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        materialOptions: MaterialOptions(
          actionBarColor: '#FF673AB7',
          statusBarColor: '#FF673AB7',
          lightStatusBar: false,
        ),
        //Todo: add iOS options
      );
      if (resultList.isNotEmpty) {
        name = transformName(resultList[0].name);
        tempByte = await resultList[0].requestOriginal();
        tempFile = await File('$path/$name').writeAsBytes(tempByte.buffer.asUint8List());
        croppedFile = await cropImage(tempFile);
        bool exist = await croppedFile.exists();
        if (exist) {
          tempImage = await compressFile(croppedFile);
        } else {
          tempImage = await compressFile(tempFile);
        }
      }
    } on PlatformException catch (e) {
      error = e.message;
      if (error != null) {
        Flushbar(
          message: error,
          icon: Icon(
            Icons.error,
            color: Colors.red,
          ),
          aroundPadding: EdgeInsets.all(8),
          borderRadius: 8,
          backgroundColor: ChsColors.dark_bkg,
          duration: Duration(seconds: 3),
        )
          ..show(context);
      }
    }
    if (!mounted) return;
    setState(() {
      images = resultList;
      finalImage = tempImage;
    });
  }

  String transformName(String name) {
    bool bl = name.contains('.jpg');
    if (!bl) {
      name = name + '.jpg';
    }
    return name;
  }

  Future<File> cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      maxHeight: 2300,
      maxWidth: 1500,
      toolbarTitle: 'Crop',
      toolbarColor: Color(0xFF673AB7),
      statusBarColor: Color(0xFF673AB7),
      toolbarWidgetColor: Colors.white,
    );
    if (croppedFile != null) {
      imageFile = croppedFile;
    }
    return imageFile;
  }

  Future<List<int>> compressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 512,
      minHeight: 512,
      quality: 100,
    );
    print(file.lengthSync());
    print(result.length);
    return result;
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
      )
        ..show(context);
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
      )
        ..show(context);
    }
  }

  Future<String> saveImage() async {
    List<int> imageData = finalImage;
    String id = uuid.v4();
    StorageReference ref = ChsCloudStorage.images(id);
    StorageUploadTask uploadTask = ref.putData(Uint8List.fromList(imageData));
    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    return url;
  }

  Future<void> register() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    String fullName = fullNameController.text.toString();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString();

    if (finalImage != null) {
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
        FirebaseUser authUser = await ChsAuth.createUserWithEmail(email, password);
        String url = await saveImage();
        if (authUser != null) {
          ChsPreferences.setBool(IS_FIRST_TIME_LOGIN, true);
          await analytics.logSignUp(signUpMethod: 'Email');
          snackBar(false, ChsStrings.snackbar_verification);
          UserUpdateInfo info = UserUpdateInfo();
          info.displayName = fullName;
          info.photoUrl = url;
          authUser.updateProfile(info);
          userCache.changeName(fullName);
          userCache.changePhotoUrl(url);
          userCache.changeEmail(authUser.email);
          ChsFirestore.token.setData(ChsFCM.tokenToMap());
          RoutePredicate predicate = (Route<dynamic> route) => false;
          Navigator.pushAndRemoveUntil(
              context,
              ChsPageRoute.fadeIn<void>(
                AuthProvider(
                  child: ExtraPage(),
                ),
              ),
              predicate);
        }
      } on PlatformException catch (e) {
        print(e);
        if (e.message != null) {
          Navigator.pop(context);
          snackBar(true, e.message);
        }
      }
    } else {
      snackBar(true, ChsStrings.snackbar_no_photo);
    }
  }
}
