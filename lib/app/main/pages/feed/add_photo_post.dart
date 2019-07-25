import 'dart:io';
import 'dart:typed_data';

import 'package:chs_connect/constants/chs_colors.dart';
import 'package:chs_connect/constants/chs_strings.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_cropper/image_cropper.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photofilters/photofilters.dart';

class PhotoPostPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PhotoPostPageState();
  }
}

class _PhotoPostPageState extends State<PhotoPostPage> with WidgetsBindingObserver {
  Widget _gridView;
  TextEditingController descController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  ScrollController scrollController;
  ChsThemeModel theme;
  List<Asset> images = List<Asset>();
  List<List<int>> pickedImages = List<List<int>>();
  List<List<int>> tempImages;
  int imageLength;
  List<File> imageFiles = List<File>();
  bool disableSharing = false;
  bool disableComment = false;
  String fileName;
  List<Filter> filters = presetFiltersList;

  Widget body(Size size) {
    return Scaffold(
      backgroundColor: theme.scaffoldColor,
      appBar: appBar(size),
      body: images.isEmpty ? emptyBody(size) : photoBody(size),
    );
  }

  Widget appBar(Size size) {
    return AppBar(
      title: Text(
        ChsStrings.new_post,
        style: theme.theme.textTheme.display1,
      ),
      brightness: theme.theme.appBarTheme.brightness,
      backgroundColor: theme.theme.appBarTheme.color,
      centerTitle: true,
      elevation: 8,
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: size.width * 0.05),
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  if (tempImages != null) {
                    setState(() {
                      pickedImages = List<List<int>>.from(tempImages);
                      imageLength = pickedImages.length;
                      _gridView = null;
                    });
                  }
                  print(pickedImages.length == tempImages.length);
                },
                child: Icon(
                  Icons.replay,
                  color: theme.iconColor,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: size.width * 0.05),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  ChsStrings.share,
                  style: TextStyle(color: theme.accentColor, fontFamily: ChsStrings.work_sans, fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        )
      ],
      leading: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: size.width * 0.04),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(this.context);
            },
            child: Icon(
              Icons.arrow_back,
              color: theme.iconColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget emptyBody(Size size) {
    return GestureDetector(
      onTap: () {
        loadImages();
      },
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.add,
              color: theme.iconColor,
              size: size.height * 0.07,
            ),
            Text(ChsStrings.tap_to_add_photo, style: theme.theme.textTheme.body1)
          ],
        ),
      ),
    );
  }

  Widget photoBody(Size size) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: imageLength > 3 ? 2 : 1,
          child: buildGridView(size),
        ),
        Flexible(
          flex: imageLength > 3 ? 3 : 4,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: <Widget>[
                Divider(
                  color: theme.textColorDisabled,
                ),
                descText(size),
                Divider(
                  color: theme.textColorDisabled,
                ),
                tags(size),
                Divider(
                  color: theme.textColorDisabled,
                ),
                ListTile(
                    title: Text(
                      ChsStrings.disable_comments,
                      style: theme.theme.textTheme.body1,
                    ),
                    trailing: Switch.adaptive(
                      activeColor: theme.accentColor,
                      value: disableComment,
                      onChanged: (value) {
                        setState(() {
                          disableComment = value;
                        });
                      },
                    )),
                Divider(
                  color: theme.textColorDisabled,
                ),
                ListTile(
                    title: Text(
                      ChsStrings.disable_sharing,
                      style: theme.theme.textTheme.body1,
                    ),
                    trailing: Switch.adaptive(
                      activeColor: theme.accentColor,
                      value: disableSharing,
                      onChanged: (value) {
                        setState(() {
                          disableSharing = value;
                        });
                      },
                    )),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildGridView(Size size) {
    if (_gridView == null) {
      _gridView = GridView.count(
        crossAxisCount: 3,
        padding: EdgeInsets.fromLTRB(size.width * 0.02, size.height * 0.01, size.width * 0.02, size.height * 0.01),
        children: List.generate(pickedImages.length, (index) {
          List<int> asset = pickedImages[index];
          return Stack(
            fit: StackFit.loose,
            alignment: Alignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  editPhoto(index);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: size.height * 0.13,
                    width: size.height * 0.13,
                    decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: MemoryImage(Uint8List.fromList(asset)),
                        )),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Material(
                  color: Colors.black45,
                  type: MaterialType.circle,
                  child: InkWell(
                    onTap: () {
                      images.removeAt(index);
                      pickedImages.removeAt(index);
                      setState(() {
                        imageLength = pickedImages.length;
                        _gridView = null;
                      });
                    },
                    child: Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          );
        }),
      );
    }
    return _gridView;
  }

  Widget descText(Size size) {
    return TextField(
      controller: descController,
      maxLength: 300,
      maxLengthEnforced: true,
      style: TextStyle(color: theme.textColorHigh, fontSize: 20),
      cursorColor: theme.accentColor,
      decoration: InputDecoration(
        hintText: ChsStrings.description,
        hintStyle: TextStyle(color: theme.textColorDisabled),
        counterStyle: TextStyle(color: theme.textColorDisabled),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.fromLTRB(size.height * 0.025, size.height * 0.01, size.height * 0.025, size.height * 0.01),
      ),
    );
  }

  Widget tags(Size size) {
    return TextField(
      controller: tagController,
      maxLength: 50,
      maxLengthEnforced: true,
      style: TextStyle(color: theme.textColorHigh, fontSize: 20),
      cursorColor: theme.accentColor,
      decoration: InputDecoration(
        hintText: ChsStrings.tag,
        hintStyle: TextStyle(color: theme.textColorDisabled),
        counterStyle: TextStyle(color: theme.textColorDisabled),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.fromLTRB(size.height * 0.025, size.height * 0.01, size.height * 0.025, size.height * 0.01),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    theme = Provider.of<ChsThemeModel>(context);
    return body(size);
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
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
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        statusBarBrightness();
        break;
    }
  }

  void statusBarBrightness() async {
    Color color = await FlutterStatusbarcolor.getStatusBarColor();
    if (useWhiteForeground(color)) {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
      FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
      await FlutterStatusbarcolor.setNavigationBarColor(color);
    } else {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
      FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
      await FlutterStatusbarcolor.setNavigationBarColor(color);
    }
  }

  bool useWhiteForeground(color) => 1.05 / (color.computeLuminance() + 0.05) > 4.5;

  Future<void> loadImages() async {
    setState(() {
      images = List<Asset>();
      tempImages = List<List<int>>();
      imageLength = 0;
    });

    List<Asset> resultList;
    ByteData tempByte;
    File tempFile;
    String error;
    String name;

    Directory tempDir = await getTemporaryDirectory();
    String path = tempDir.path;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        materialOptions: MaterialOptions(
          actionBarColor: ChsStrings.default_accent,
          statusBarColor: ChsStrings.default_accent,
          lightStatusBar: false,
        ),
        //Todo: add iOS options
      );

      for (Asset asset in resultList) {
        tempByte = await asset.requestOriginal();
        name = transformName(asset.name);
        tempFile = await File('$path/$name').writeAsBytes(tempByte.buffer.asUint8List());
        pickedImages.add(tempByte.buffer.asUint8List());
        tempImages.add(tempByte.buffer.asUint8List());
        imageFiles.add(tempFile);
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
        )..show(this.context);
      }
    }
    if (!mounted) return;
    setState(() {
      images = resultList;
      imageLength = resultList.length;
    });
  }

  Future<void> editPhoto(int index) async {
    fileName = basename(imageFiles[index].path);
    var image = imageLib.decodeImage(pickedImages[index]);
    image = imageLib.copyResize(image, width: 600);
    File filteredImage;
    File croppedImage;
    List<int> finalImage;
    Map imageFile = await Navigator.push(
      this.context,
      new MaterialPageRoute(
        builder: (context) => Provider<ChsThemeModel>.value(
          value: theme,
          child: Theme(
            data: theme.theme,
            child: PhotoFilterSelector(
              title: Text(
                ChsStrings.filter,
                style: theme.theme.textTheme.display1,
              ),
              image: image,
              filters: presetFiltersList,
              filename: fileName,
              loader: Center(child: CircularProgressIndicator()),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
    if (imageFile != null && imageFile.containsKey('image_filtered')) {
      setState(() {
        filteredImage = imageFile['image_filtered'];
      });
      croppedImage = await cropImage(filteredImage);
      bool exist = await croppedImage.exists();
      if (exist) {
        finalImage = await compressFile(croppedImage);
        if (finalImage != null) {
          setState(() {
            pickedImages[index] = finalImage;
            _gridView = null;
          });
        }
      }
    }
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
      toolbarTitle: ChsStrings.crop,
      toolbarColor: ChsColors.default_accent,
      statusBarColor: ChsColors.default_accent,
      toolbarWidgetColor: Colors.white,
      controlWidgetColor: ChsColors.default_accent,
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
    return result;
  }
}
