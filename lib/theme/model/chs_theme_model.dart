import 'package:chs_connect/constants/chs_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:localstorage/localstorage.dart';

export 'package:provider/provider.dart';

enum ChsThemeType { light, dark, custom }

class ChsThemeModel extends ChangeNotifier {
  ChsThemeModel({
    this.customLightTheme,
    this.customDarkTheme,
    this.customCustomTheme,
    String key,
  }) : _storage = LocalStorage("app_theme");

  final ThemeData customLightTheme, customDarkTheme, customCustomTheme;

  int _accentColor = ChsColors.default_accent.value;
  bool _customMode = false;
  int _darkAccentColor = ChsColors.default_accent.value;
  bool _darkMode = false;
  bool _lightMode = false;
  int _primaryColor = ChsColors.default_primary.value;
  int _scaffoldColor = ChsColors.default_scaffold.value;
  int _backgroundColor = ChsColors.default_bkg.value;
  int _textHigh = ChsColors.dark_text_high.value;
  int _textMedium = ChsColors.dark_text_medium.value;
  int _textDisabled = ChsColors.dark_text_disabled.value;
  int _iconColor = Colors.black.value;
  LocalStorage _storage;


  ChsThemeType get type {
    if (_darkMode) {
      _lightMode = false;
      _customMode = false;
      return ChsThemeType.dark;
    }
    if (_customMode) {
      _lightMode = false;
      _darkMode = false;
      return ChsThemeType.custom;
    }
    _lightMode = true;
    return ChsThemeType.light;
  }

  void changeDarkMode(bool value) {
    _darkMode = value;
    _storage.setItem("dark_mode", _darkMode);
    notifyListeners();
  }

  void changeCustomTheme(bool value) {
    _customMode = value;
    _storage.setItem("custom_theme", _customMode);
    notifyListeners();
  }

  void changePrimaryColor(Color value) {
    _primaryColor = value.value;
    _storage.setItem("primary_color", _primaryColor);
    notifyListeners();
  }

  void changeAccentColor(Color value) {
    _accentColor = value.value;
    _storage.setItem("accent_color", _accentColor);
    notifyListeners();
  }

  void changeDarkAccentColor(Color value) {
    _darkAccentColor = value.value;
    _storage.setItem("dark_accent_color", _darkAccentColor);
    notifyListeners();
  }

  void changeScaffoldColor(Color value) {
    _scaffoldColor = value.value;
    _storage.setItem("scaffold_color", _scaffoldColor);
    notifyListeners();
  }

  void changeIconColor(Color value) {
    _iconColor = value.value;
    _storage.setItem("icon_color", _iconColor);
    notifyListeners();
  }

  void changeBackgroundColor(Color value) {
    _backgroundColor = value.value;
    _storage.setItem("background_color", _backgroundColor);
    notifyListeners();
  }

  void changeTextHighColor(Color value) {
    _textHigh = value.value;
    _storage.setItem("text_high_color", _textHigh);
    notifyListeners();
  }

  void changeTextMediumColor(Color value) {
    _textMedium = value.value;
    _storage.setItem("text_medium_color", _textMedium);
    notifyListeners();
  }

  void changeTextDisabledColor(Color value) {
    _textDisabled = value.value;
    _storage.setItem("text_disabled_color", _textDisabled);
    notifyListeners();
  }

  ThemeData get theme {
    if (_storage == null) {
      init();
    }
    if (_lightMode) {
      lightStatusbar();
    }
    if (_darkMode) {
      darkStatusbar();
    }
    switch (type) {
      case ChsThemeType.light:
        return customLightTheme ??
            ThemeData.light().copyWith(
              backgroundColor: ChsColors.default_bkg,
              canvasColor: ChsColors.default_primary,
              scaffoldBackgroundColor: ChsColors.default_scaffold,
              primaryColor: ChsColors.default_primary,
              accentColor: ChsColors.default_accent,
              appBarTheme: AppBarTheme(
                brightness: Brightness.light,
                color: ChsColors.default_primary,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.black,),
                actionsIconTheme: IconThemeData(color: Colors.black,),
                textTheme: TextTheme(title: TextStyle(
                    color: ChsColors.default_text_high,
                    fontFamily: "Work Sans",
                    fontSize: 20,
                    fontWeight: FontWeight.w500),),
              ),
              iconTheme: IconThemeData(color: Colors.black),
              textTheme: TextTheme(
                title: TextStyle(
                    color: ChsColors.default_text_high,
                    fontFamily: "Work Sans",
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
                body1: TextStyle(
                    color: ChsColors.default_text_high,
                    fontFamily: "Work Sans",
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                body2: TextStyle(
                    color: ChsColors.default_text_medium,
                    fontFamily: "Work Sans",
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
                display1: TextStyle(
                    color: ChsColors.default_text_high,
                    fontFamily: "Rochester",
                    fontSize: 34,
                    fontWeight: FontWeight.w400),
                button: TextStyle(
                    color: ChsColors.default_text_high,
                    fontFamily: "Work Sans",
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                caption: TextStyle(
                    color: ChsColors.default_text_disabled,
                    fontFamily: "Work Sans",
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
              dialogTheme: DialogTheme(
                backgroundColor: ChsColors.default_bkg,
                elevation: 6,
                titleTextStyle: TextStyle(
                    color: ChsColors.default_text_high,
                    fontFamily: "Work Sans",
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
                contentTextStyle: TextStyle(
                    color: ChsColors.default_text_high,
                    fontFamily: "Work Sans",
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                ),
              ),
              errorColor: ChsColors.default_error,
              tabBarTheme: TabBarTheme(
                indicator: UnderlineTabIndicator(borderSide: BorderSide(color: ChsColors.default_accent, width: 2.0)),
                labelColor: ChsColors.default_accent,
                labelStyle: TextStyle(
                    color: ChsColors.default_text_medium,
                    fontFamily: "Work Sans",
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
                unselectedLabelColor: Colors.black,
                unselectedLabelStyle: TextStyle(
                    color: ChsColors.default_accent,
                    fontFamily: "Work Sans",
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            );
      case ChsThemeType.dark:
        return customDarkTheme ??
            ThemeData.dark().copyWith(
              backgroundColor: ChsColors.dark_bkg,
              canvasColor: ChsColors.dark_primary,
              scaffoldBackgroundColor: ChsColors.dark_scaffold,
              primaryColor: ChsColors.dark_primary,
              accentColor: darkAccentColor ?? ChsColors.default_accent,
              appBarTheme: AppBarTheme(
                brightness: Brightness.dark,
                color: ChsColors.dark_primary,
                elevation: 0,
                iconTheme: IconThemeData(color: ChsColors.dark_icon),
                actionsIconTheme: IconThemeData(color: ChsColors.dark_icon),
              ),
              iconTheme: IconThemeData(color: ChsColors.dark_icon),
              textTheme: TextTheme(
                title: TextStyle(
                    color: ChsColors.dark_text_high,
                    fontFamily: "Work Sans",
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
                body1: TextStyle(
                    color: ChsColors.dark_text_high,
                    fontFamily: "Work Sans",
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
                body2: TextStyle(
                    color: ChsColors.dark_text_medium,
                    fontFamily: "Work Sans",
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
                display1: TextStyle(
                    color: ChsColors.dark_text_high,
                    fontFamily: "Rochester",
                    fontSize: 34,
                    fontWeight: FontWeight.w400),
                button: TextStyle(
                    color: ChsColors.dark_text_high,
                    fontFamily: "Work Sans",
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                caption: TextStyle(
                    color: ChsColors.dark_text_disabled,
                    fontFamily: "Work Sans",
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
              dialogTheme: DialogTheme(
                backgroundColor: ChsColors.dark_bkg,
                elevation: 16,
                titleTextStyle: TextStyle(
                    color: ChsColors.dark_text_high,
                    fontFamily: "Work Sans",
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
                contentTextStyle: TextStyle(
                    color: ChsColors.dark_text_high,
                    fontFamily: "Work Sans",
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                ),
              ),
              errorColor: ChsColors.dark_error,
              tabBarTheme: TabBarTheme(
                indicator: UnderlineTabIndicator(borderSide: BorderSide(color: darkAccentColor ?? ChsColors.default_accent, width: 2.0)),
                labelColor: darkAccentColor ?? ChsColors.default_accent,
                labelStyle: TextStyle(
                    color: ChsColors.dark_text_medium,
                    fontFamily: "Work Sans",
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
                unselectedLabelColor: ChsColors.dark_text_medium,
                unselectedLabelStyle: TextStyle(
                    color: darkAccentColor ?? ChsColors.default_accent,
                    fontFamily: "Work Sans",
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            );
      case ChsThemeType.custom:
        return customCustomTheme != null
            ? customCustomTheme.copyWith(
                backgroundColor: backgroundColor ?? ChsColors.default_bkg,
          canvasColor: primaryColor ?? ChsColors.default_primary,
                scaffoldBackgroundColor:
                    scaffoldColor ?? ChsColors.default_scaffold,
                primaryColor: primaryColor ?? ChsColors.default_primary,
                accentColor: accentColor ?? ChsColors.default_accent,
                appBarTheme: AppBarTheme(
                  brightness: useWhiteForeground(primaryColor) ? Brightness.light : Brightness.dark,
                  color: primaryColor ?? ChsColors.default_primary,
                  elevation: 0,
                  iconTheme: IconThemeData(color: iconColor ?? Colors.black),
                  actionsIconTheme: IconThemeData(color: iconColor ?? Colors.black),
                ),
                iconTheme: IconThemeData(color: iconColor ?? Colors.black),
                textTheme: TextTheme(
                  title: TextStyle(
                      color: textColorHigh ?? ChsColors.default_text_high,
                      fontFamily: "Work Sans",
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                  body1: TextStyle(
                      color: textColorHigh ?? ChsColors.default_text_high,
                      fontFamily: "Work Sans",
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                  body2: TextStyle(
                      color: textColorMedium ?? ChsColors.default_text_medium,
                      fontFamily: "Work Sans",
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  display1: TextStyle(
                      color: textColorHigh ?? ChsColors.default_text_high,
                      fontFamily: "Rochester",
                      fontSize: 34,
                      fontWeight: FontWeight.w400),
                  button: TextStyle(
                      color: textColorHigh ?? ChsColors.default_text_high,
                      fontFamily: "Work Sans",
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                  caption: TextStyle(
                      color:
                          textColorDisabled ?? ChsColors.default_text_disabled,
                      fontFamily: "Work Sans",
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
                dialogTheme: DialogTheme(
                  backgroundColor: backgroundColor ?? ChsColors.default_bkg,
                  elevation: 6,
                  titleTextStyle: TextStyle(
                      color: textColorHigh ?? ChsColors.default_text_high,
                      fontFamily: "Work Sans",
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                  contentTextStyle: TextStyle(
                      color: textColorHigh ?? ChsColors.default_text_high,
                      fontFamily: "Work Sans",
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),
                ),
                errorColor: ChsColors.default_error,
          tabBarTheme: TabBarTheme(
            indicator: UnderlineTabIndicator(borderSide: BorderSide(color: accentColor ?? ChsColors.default_accent, width: 2.0)),
            labelColor: accentColor ?? ChsColors.default_accent,
            labelStyle: TextStyle(
                color: textColorMedium ?? ChsColors.default_text_medium,
                fontFamily: "Work Sans",
                fontSize: 14,
                fontWeight: FontWeight.w400),
            unselectedLabelColor: textColorMedium ?? ChsColors.default_text_medium,
            unselectedLabelStyle: TextStyle(
                color: accentColor ?? ChsColors.default_accent,
                fontFamily: "Work Sans",
                fontSize: 14,
                fontWeight: FontWeight.w400),
          ),
              )
            : ThemeData.light().copyWith(
                backgroundColor: backgroundColor ?? ChsColors.default_bkg,
          canvasColor: primaryColor ?? ChsColors.default_primary,
                scaffoldBackgroundColor:
                    scaffoldColor ?? ChsColors.default_scaffold,
                primaryColor: primaryColor ?? ChsColors.default_primary,
                accentColor: accentColor ?? ChsColors.default_accent,
                appBarTheme: AppBarTheme(
                  brightness: useWhiteForeground(primaryColor) ? Brightness.light : Brightness.dark,
                  color: primaryColor ?? ChsColors.default_primary,
                  elevation: 0,
                  iconTheme: IconThemeData(color: iconColor ?? Colors.black),
                  actionsIconTheme: IconThemeData(color: iconColor ?? Colors.black),
                ),
                iconTheme: IconThemeData(color: iconColor ?? Colors.black),
                textTheme: TextTheme(
                  title: TextStyle(
                      color: textColorHigh ?? ChsColors.default_text_high,
                      fontFamily: "Work Sans",
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                  body1: TextStyle(
                      color: textColorHigh ?? ChsColors.default_text_high,
                      fontFamily: "Work Sans",
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                  body2: TextStyle(
                      color: textColorMedium ?? ChsColors.default_text_medium,
                      fontFamily: "Work Sans",
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  display1: TextStyle(
                      color: textColorHigh ?? ChsColors.default_text_high,
                      fontFamily: "Rochester",
                      fontSize: 34,
                      fontWeight: FontWeight.w400),
                  button: TextStyle(
                      color: textColorHigh ?? ChsColors.default_text_high,
                      fontFamily: "Work Sans",
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                  caption: TextStyle(
                      color:
                          textColorDisabled ?? ChsColors.default_text_disabled,
                      fontFamily: "Work Sans",
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
                dialogTheme: DialogTheme(
                  backgroundColor: backgroundColor ?? ChsColors.default_bkg,
                  elevation: 6,
                  titleTextStyle: TextStyle(
                      color: textColorHigh ?? ChsColors.default_text_high,
                      fontFamily: "Work Sans",
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                  contentTextStyle: TextStyle(
                      color: textColorHigh ?? ChsColors.default_text_high,
                      fontFamily: "Work Sans",
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),
                ),
                errorColor: ChsColors.default_error,
          tabBarTheme: TabBarTheme(
            indicator: UnderlineTabIndicator(borderSide: BorderSide(color: accentColor ?? ChsColors.default_accent, width: 2.0)),
            labelColor: accentColor ?? ChsColors.default_accent,
            labelStyle: TextStyle(
                color: textColorMedium ?? ChsColors.default_text_medium,
                fontFamily: "Work Sans",
                fontSize: 14,
                fontWeight: FontWeight.w400),
            unselectedLabelColor: textColorMedium ?? ChsColors.default_text_medium,
            unselectedLabelStyle: TextStyle(
                color: accentColor ?? ChsColors.default_accent,
                fontFamily: "Work Sans",
                fontSize: 14,
                fontWeight: FontWeight.w400),
          ),
              );
      default:
        return customLightTheme ?? ThemeData.light().copyWith();
    }
  }

  Color get backgroundColor {
    if (darkMode) {
      return ChsColors.dark_bkg;
    }
    if (customTheme) return bkgColor;
    return ChsColors.default_bkg;
  }

  Color get textColorHigh {
    if (customTheme) return textHigh;
    if (darkMode) return ChsColors.dark_text_high;
    return Colors.black;
  }

  Color get textColorMedium {
    if (customTheme) return textMedium;
    if (darkMode) return ChsColors.dark_text_medium;
    return Colors.black;
  }

  Color get textColorDisabled {
    if (customTheme) return textDisabled;
    if (darkMode) return ChsColors.dark_text_disabled;
    return Colors.black;
  }

  Future init() async {
    if (await _storage.ready) {
      _darkMode = _storage.getItem("dark_mode") ?? false;
      _customMode = _storage.getItem("custom_theme") ?? false;
      _primaryColor = _storage.getItem("primary_color");
      _accentColor = _storage.getItem("accent_color");
      _darkAccentColor = _storage.getItem("dark_accent_color");
      _iconColor = _storage.getItem("icon_color");
      _backgroundColor = _storage.getItem("background_color");
      _scaffoldColor = _storage.getItem("scaffold_color");
      _textHigh = _storage.getItem("text_high_color");
      _textMedium = _storage.getItem("text_medium_color");
      _textDisabled = _storage.getItem("text_disabled_color");
      notifyListeners();
    }
  }

  bool get darkMode => _darkMode ?? type == ChsThemeType.dark;

  bool get lightMode => _lightMode ?? type == ChsThemeType.light;

  bool get customTheme => _customMode ?? type == ChsThemeType.custom;

  Color get primaryColor {
    if (_primaryColor == null) {
      return type == ChsThemeType.dark
          ? ChsColors.dark_primary
          : ChsColors.default_primary;
    }
    if (_customMode) {
      Color temp = Color(_primaryColor);
      customStatusbar(temp);
    }
    return Color(_primaryColor);
  }

  Color get bkgColor {
    if (_backgroundColor == null) {
      return type == ChsThemeType.dark
          ? ChsColors.dark_bkg
          : ChsColors.default_bkg;
    }
    return Color(_backgroundColor);
  }

  Color get accentColor {
    if (type == ChsThemeType.dark) {
      if (_darkAccentColor == null) {
        return ChsColors.default_accent;
      }
      return Color(_darkAccentColor);
    }
    if (_accentColor == null) return ChsColors.default_accent;
    if (_customMode) return Color(_accentColor);
    return ChsColors.default_accent;
  }

  Color get darkAccentColor {
    if (_darkAccentColor == null) return ChsColors.default_accent;
    return Color(_darkAccentColor);
  }

  Color get textHigh {
    if (_textHigh == null) return ChsColors.default_text_high;
    return Color(_textHigh);
  }

  Color get textMedium {
    if (_textMedium == null) return ChsColors.default_text_medium;
    return Color(_textMedium);
  }

  Color get textDisabled {
    if (_textDisabled == null) return ChsColors.default_text_disabled;
    return Color(_textDisabled);
  }

  Color get iconColor {
    if (_darkMode) {
      if (_iconColor == null) {
        return ChsColors.dark_icon;
      }
      return ChsColors.dark_icon;
    }
    if (_customMode) {
      if (_iconColor == null) return Colors.black;
      return Color(_iconColor);
    }
    return Colors.black;
  }

  Color get scaffoldColor {
    if (_darkMode) {
      if (_scaffoldColor == null) {
        return ChsColors.dark_scaffold;
      }
      return ChsColors.dark_scaffold;
    }
    if (_customMode) {
      if (_scaffoldColor == null) return ChsColors.default_scaffold;
      return Color(_scaffoldColor);
    }
    if (_scaffoldColor == null) return ChsColors.default_scaffold;
    return Color(_scaffoldColor);
  }

  void reset() {
    _storage.clear();
    _darkMode = false;
    _customMode = false;
    _primaryColor = ChsColors.default_primary.value;
    _accentColor = ChsColors.default_accent.value;
    _darkAccentColor = ChsColors.default_accent.value;
    _scaffoldColor = ChsColors.default_scaffold.value;
    _backgroundColor = ChsColors.default_bkg.value;
    _iconColor = Colors.black.value;
    _textHigh = ChsColors.dark_text_high.value;
    _textMedium = ChsColors.dark_text_medium.value;
    _textDisabled = ChsColors.dark_text_disabled.value;
  }

  void darkStatusbar() async {
    await FlutterStatusbarcolor.setStatusBarColor(ChsColors.dark_primary);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    await FlutterStatusbarcolor.setNavigationBarColor(Colors.black);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
  }

  void lightStatusbar() async {
    await FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    await FlutterStatusbarcolor.setNavigationBarColor(Colors.white);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
  }

  void customStatusbar(Color _color) async {
    if (useWhiteForeground(_color)) {
      await FlutterStatusbarcolor.setStatusBarColor(_color);
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
      await FlutterStatusbarcolor.setNavigationBarColor(_color);
      FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
    } else {
      await FlutterStatusbarcolor.setStatusBarColor(_color);
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
      await FlutterStatusbarcolor.setNavigationBarColor(_color);
      FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
    }
  }

  bool useWhiteForeground(color) => 1.05 / (color.computeLuminance() + 0.05) > 4.5;
}
