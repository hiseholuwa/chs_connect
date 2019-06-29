import 'package:chs_connect/utils/chs_formatter.dart';
import 'package:flutter/services.dart';

class ChsPhone extends ChsFormatter {
  static final RegExp _digitOnlyRegex = RegExp(r'\d+');
  static final _digitFormatter = WhitelistingTextInputFormatter(_digitOnlyRegex);

  @override
  String formatPattern(String digits) {
    StringBuffer result = StringBuffer();

    for (var i = 0; i < digits.length; i++) {
      if (i == 0) {
        result.write('(');
      } else if (i == 3) {
        result.write(') ');
      } else if (i == 6) {
        result.write('-');
      } else if (i == 10) {
        result.write('-');
      }

      result.write(digits[i]);
    }
    return result.toString();
  }

  @override
  TextEditingValue formatValue(TextEditingValue oldValue, TextEditingValue newValue) {
    return _digitFormatter.formatEditUpdate(oldValue, newValue);
  }

  @override
  bool isUserInput(String s) {
    return _digitOnlyRegex.firstMatch(s) != null;
  }
}
