import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class TransparentHexColor extends Color {
  static int _getColorFromHex(String hexColor, String transparency) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = transparency + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  TransparentHexColor(final String hexColor, final String transparency)
      : super(_getColorFromHex(hexColor, transparency));
}
