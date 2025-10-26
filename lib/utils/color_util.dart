import 'package:flutter/material.dart';

extension HexColor on Color {
  static Color fromHex(String hexString, {String defaultStr = '#b2b2b2'}) {
    var _str = hexString;
    if (_str.isEmpty) _str = defaultStr;
    final buffer = StringBuffer();
    if (_str.length == 6 || _str.length == 7) buffer.write('ff');
    buffer.write(_str.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
