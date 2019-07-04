import 'dart:async';

import 'package:chs_connect/constants/chs_colors.dart';
import 'package:chs_connect/constants/chs_strings.dart';
import 'package:chs_connect/theme/model/chs_theme_model.dart';
import 'package:chs_connect/utils/chs_map_state_manager.dart';
import 'package:chs_connect/utils/chs_user_cache.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  ChsThemeModel theme;
  ChsUserCache userCache;
  bool permissionState = true;

  //map
  LocationData _startLocation;
  LocationData _currentLocation;
  StreamSubscription<LocationData> _locationSubscription;
  Location _locationService = new Location();
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _currentCameraPosition;
  GoogleMap googleMap;
  CameraPosition savedCameraPosition;
  bool exist = false;
  static final CameraPosition _initialCamera = CameraPosition(
    target: LatLng(0, 0),
    zoom: 4,
  );

  Widget buildError(Size size) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: size.width * 0.1, right: size.width * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.error_outline, size: size.height * 0.3, color: Colors.red,),
            Padding(padding: EdgeInsets.only(bottom: size.height * 0.1),),
            Text(ChsStrings.map_ask_text),
            Padding(padding: EdgeInsets.only(bottom: size.height * 0.05),),
            permissionBtn(size),
          ],
        ),
      ),
      extendBody: true,
    );
  }

  Widget permissionBtn(size) {
    var height = size.height;
    var width = size.width;
    return Container(
      width: width * 0.6,
      padding: EdgeInsets.only(
        top: 5,
        bottom: height * 0.015,
        left: height * 0.015,
        right: height * 0.015,
      ),
      child: RaisedButton(
        color: ChsColors.default_accent,
        padding: EdgeInsets.symmetric(vertical: height * 0.02),
        onPressed: () {
          askPermission();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(height * 0.05)),
        ),
        child: Text(ChsStrings.map_ask_btn, style: TextStyle(color: Colors.white, fontSize: 17)),
      ),
    );
  }

  Widget buildMap(Size size) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        initialCameraPosition: exist ? savedCameraPosition : _initialCamera,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        onCameraMove: (position) {
          ChsMapStateManager.saveMapState(position, LatLng(_currentLocation.latitude, _currentLocation.longitude));
        },

      ),
      extendBody: true,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {},
            child: Icon(CommunityMaterialIcons.crosshairs_gps, color: ChsColors.default_accent,),
            backgroundColor: Colors.white,
          ),
          Padding(padding: EdgeInsets.only(bottom: size.height * 0.1),),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    theme = Provider.of<ChsThemeModel>(context);
    userCache = Provider.of<ChsUserCache>(context);
    return permissionState ? buildMap(deviceSize) : buildError(deviceSize);
  }

  @override
  void initState() {
    super.initState();
    changeStatusBar();
    checkPermission();
    initMapState();
    initPlatformState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void changeStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Color(0x03FFFFFF), statusBarIconBrightness: Brightness.dark));
  }

  void initMapState() async {
    savedCameraPosition = await ChsMapStateManager.getSavedCameraPosition();
    print(savedCameraPosition.toString());
    if (savedCameraPosition
        .toString()
        .isEmpty) {
      setState(() {
        exist = false;
      });
    } else {
      setState(() {
        exist = true;
      });
    }
  }


  void checkPermission() async {
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
    switch (permission) {
      case PermissionStatus.unknown:
        Map<PermissionGroup, PermissionStatus> permissionResults = await PermissionHandler().requestPermissions([PermissionGroup.location]);
        PermissionStatus status = permissionResults[PermissionGroup.location];
        switch (status) {
          case PermissionStatus.granted:
            setState(() {
              permissionState = true;
            });
            initPlatformState();
            break;
          case PermissionStatus.denied:
            setState(() {
              permissionState = false;
            });
            break;
        }
        break;
      case PermissionStatus.denied:
        setState(() {
          permissionState = false;
        });
        resolvePermission();
        break;
      case PermissionStatus.granted:
        setState(() {
          permissionState = true;
        });
    }
  }

  void askPermission() async {
    Map<PermissionGroup, PermissionStatus> permissionResults = await PermissionHandler().requestPermissions([PermissionGroup.location]);
    PermissionStatus status = permissionResults[PermissionGroup.location];
    switch (status) {
      case PermissionStatus.granted:
        setState(() {
          permissionState = true;
        });
        initPlatformState();
        break;
      case PermissionStatus.denied:
        setState(() {
          permissionState = false;
        });
    }
  }

  void resolvePermission() async {
    final size = MediaQuery
        .of(context)
        .size;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(ChsStrings.map_alert_title),
            titleTextStyle: TextStyle(color: ChsColors.default_accent, fontFamily: ChsStrings.work_sans, fontSize: 25, fontWeight: FontWeight.w500),
            content: SizedBox(
              height: size.height * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(ChsStrings.map_alert_text1),
                  Text(ChsStrings.map_alert_text2),
                  Text(ChsStrings.map_alert_text3),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(ChsStrings.map_alert_btn1),
                onPressed: () {
                  setState(() {
                    permissionState = false;
                  });
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(ChsStrings.map_alert_btn2),
                onPressed: () async {
                  Navigator.pop(context);
                  Map<PermissionGroup, PermissionStatus> permissionResults = await PermissionHandler().requestPermissions([PermissionGroup.location]);
                  PermissionStatus status = permissionResults[PermissionGroup.location];
                  switch (status) {
                    case PermissionStatus.granted:
                      setState(() {
                        permissionState = true;
                      });
                      initPlatformState();
                      break;
                    case PermissionStatus.denied:
                      setState(() {
                        permissionState = false;
                      });
                  }
                },
              ),
            ],

          );
        }
    );
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

  initPlatformState() async {
    await _locationService.changeSettings(accuracy: LocationAccuracy.BALANCED, interval: 1000);
    LocationData location;
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      if (serviceStatus) {
        if (permissionState) {
          location = await _locationService.getLocation();
          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newLatLng(LatLng(location.latitude, location.longitude)));
          _locationSubscription = _locationService.onLocationChanged().listen((LocationData result) async {
            _currentCameraPosition = CameraPosition(
                target: LatLng(result.latitude, result.longitude),
                zoom: 16
            );
            LatLng savedLocation = LatLng(result.latitude, result.longitude);
            print(savedLocation);
            print(location.speed);
            ChsMapStateManager.saveMapState(_currentCameraPosition, savedLocation);
            final GoogleMapController controller = await _controller.future;
            if (location.speed > 2.0) {
              controller.animateCamera(CameraUpdate.newCameraPosition(_currentCameraPosition));
            }
            if (mounted) {
              setState(() {
                _currentLocation = result;
              });
            }
          });
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        if (serviceStatusResult) {
          initPlatformState();
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        snackBar(true, e.message);
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        snackBar(true, e.message);
      }
      location = null;
    }

    setState(() {
      _startLocation = location;
    });
  }


}
