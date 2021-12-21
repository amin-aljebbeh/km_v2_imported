import 'package:flutter/material.dart';

class ColorUtils {
  Color primaryColor = HexColor("35637c"); // كحلي
  Color greyColor = HexColor("35637c"); //
  Color searchGreyColor = HexColor("e6e6e6");
  Color darkColor = HexColor("3D56F0");
  Color violetColor = HexColor("5120AE");
  Color lightVioletColor = HexColor("7085C3");

  Color kmColors = Color.fromARGB(255, 210, 178, 2);
  Color blueColor = HexColor("396b89");

  Color kmColors2 = HexColor("e5cb37");

  Color khawajaColor = Colors.purple;
  Color vegetableColor = Colors.green[800];
  Color libraryColor = Colors.indigo;
  Color normalColor = Colors.transparent;
  Color meetColor = Colors.deepOrange;
  Color pharmaColor = Colors.blueAccent;
  Color amourColor = Colors.red;
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
