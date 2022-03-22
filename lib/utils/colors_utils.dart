import 'package:flutter/material.dart';

class ColorUtils {
  static Color primaryColor = HexColor("35637c"); //
  static Color greyColor = HexColor("35637c"); //
  static Color searchGreyColor = HexColor("e6e6e6");
  static Color vegetableColor = const Color.fromRGBO(191, 228, 193, 1);
  static Color kmColors = const Color.fromARGB(255, 210, 178, 2);

  static Color kmColors2 = HexColor("e5cb37");
}

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
