import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChsColors {
  ChsColors._();

  static const Color auth_bkg = const Color(0xFF212121);
  static const Color default_accent = const Color(0xFF185ABB);
  static const Color default_bkg = const Color(0xFFFFFFFF);
  static const Color default_primary = const Color(0xFFFFFFFF);
  static const Color default_scaffold = const Color(0xFFFFFFFF);
  static const Color default_text_high = const Color(0xDE000000);
  static const Color default_text_medium = const Color(0x99000000);
  static const Color default_text_disabled = const Color(0x61000000);
  static const Color default_error = const Color(0xFFB00020);

  static const Color dark_bkg = const Color(0xFF202125);
  static const Color dark_primary = const Color(0xFF202125);
  static const Color dark_scaffold = const Color(0xFF202125);
  static const Color dark_text_high = const Color(0xFFFFFFFF);
  static const Color dark_text_medium = const Color(0xDEFFFFFF);
  static const Color dark_text_disabled = const Color(0x99FFFFFF);
  static const Color dark_error = const Color(0xFFCF6679);
  static const Color dark_icon = const Color(0xFFFFFFFF);


  static const ColorSwatch white = const MaterialColor(
    0xFFFFFFFF,
    const <int, Color>{
      50: const Color(0xFFFFFFFF),
      100: const Color(0xFFFAFAFA),
      200: const Color(0xFFF5F5F5),
      300: const Color(0xFFF0F0F0),
      400: const Color(0xFFDEDEDE),
      500: const Color(0xFFFFFFFF),
      600: const Color(0xFF979797),
      700: const Color(0xFF818181),
      800: const Color(0xFF606060),
      900: const Color(0xFF3C3C3C),
    },
  );

  static const ColorSwatch black = const MaterialColor(
    0xFF000000,
    const <int, Color>{
      50: const Color(0xFFF5F5F5),
      100: const Color(0xFFE9E9E9),
      200: const Color(0xFFD9D9D9),
      300: const Color(0xFFC4C4C4),
      400: const Color(0xFF9D9D9D),
      500: const Color(0xFF000000),
      600: const Color(0xFF555555),
      700: const Color(0xFF434343),
      800: const Color(0xFF262626),
      900: const Color(0xFF000000),
    },
  );
}
