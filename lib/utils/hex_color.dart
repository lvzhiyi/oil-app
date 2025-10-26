import 'dart:ui';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor, double alpha) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    var opacity = (alpha * 255).round();

    if (hexColor.length == 6) {
      hexColor = "${opacity.toRadixString(16)}$hexColor";
    }

    if (hexColor.isEmpty) {
      return int.parse('${opacity.toRadixString(16)}ffffff', radix: 16);
    }

    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor, [double? alpha])
      : super(_getColorFromHex(hexColor, alpha ?? 1));
}
