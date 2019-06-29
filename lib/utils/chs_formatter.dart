import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

abstract class ChsFormatter extends TextInputFormatter {
  bool isUserInput(String s);

  String formatPattern(String digits);

  TextEditingValue formatValue(TextEditingValue oldValue, TextEditingValue newValue);

  TextEditingValue _previousNewValue;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue == _previousNewValue) {
      return oldValue;
    }
    _previousNewValue = newValue;

    var value = formatValue(oldValue, newValue);
    var selectionIndex = value.selection.end;

    final result = formatPattern(value.text);

    var insertedSeparatorsCount = 0;
    var insertedByUserCount = 0;
    for (int i = 0; i < result.length && insertedByUserCount < selectionIndex; i++) {
      final character = result[i];
      if (isUserInput(character)) {
        insertedByUserCount++;
      } else {
        insertedSeparatorsCount++;
      }
    }

    selectionIndex = min(selectionIndex + insertedSeparatorsCount, result.length);

    if (selectionIndex - 1 >= 0 && selectionIndex - 1 < result.length && !isUserInput(result[selectionIndex - 1])) {
      selectionIndex--;
    }

    return value.copyWith(
        text: result, selection: TextSelection.collapsed(offset: selectionIndex), composing: defaultTargetPlatform == TargetPlatform.iOS ? TextRange(start: 0, end: 0) : TextRange.empty);
  }
}
