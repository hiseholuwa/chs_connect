import 'package:chs_connect/utils/chs_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChsMapStateManager {
  ChsMapStateManager._();

  static const String _LONGITUDE = "longitude";
  static const String _LATITUDE = "latitude";
  static const String _ZOOM = "zoom";
  static const String _BEARING = "bearing";
  static const String _TILT = "tilt";

  static saveMapState(CameraPosition position, LatLng location) {
    ChsPreferences.setDouble(_LONGITUDE, location.longitude);
    ChsPreferences.setDouble(_LATITUDE, location.latitude);
    ChsPreferences.setDouble(_ZOOM, position.zoom);
    ChsPreferences.setDouble(_BEARING, position.bearing);
    ChsPreferences.setDouble(_TILT, position.tilt);
  }

  static Future<CameraPosition> getSavedCameraPosition() async {
    double lat = await ChsPreferences.getDouble(_LATITUDE);
    double long = await ChsPreferences.getDouble(_LONGITUDE);
    LatLng target = LatLng(lat, long);

    double zoom = await ChsPreferences.getDouble(_ZOOM);
    double bearing = await ChsPreferences.getDouble(_BEARING);
    double tilt = await ChsPreferences.getDouble(_TILT);

    CameraPosition position = new CameraPosition(bearing: bearing, target: target, tilt: tilt, zoom: zoom);
    return position;
  }
}
