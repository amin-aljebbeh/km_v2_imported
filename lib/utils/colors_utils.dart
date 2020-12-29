import 'package:flutter/material.dart'; 
import 'package:kammun_app/utils/tools.dart';

class ColorUtils {
  // Color.fromARGB(255, 210, 178, 2) كموني
//Color.fromARGB(255, 53, 99, 124) كجلي

  // Color primarycolor = HexColor("f74269");
  // Color greycolor = HexColor("929794");
  // Color searchgreycolor = HexColor("e6e6e6");
  // Color darkcolor = HexColor("3D56F0");
  // Color bluecolor = HexColor("5468FF");
  // Color violetcolor = HexColor("5120AE");
  // Color lightVioletColor = HexColor("7085C3");

  Color primarycolor = HexColor("35637c"); // كحلي
  Color greycolor = HexColor("35637c"); //
  Color searchgreycolor = HexColor("e6e6e6");
  Color darkcolor = HexColor("3D56F0");
  Color bluecolor = HexColor("5468FF");
  Color violetcolor = HexColor("5120AE");
  Color lightVioletColor = HexColor("7085C3");

  Color kmColors = Color.fromARGB(255, 210, 178, 2);
  Color blueColor = HexColor("396b89");

  Color kmColors2 = HexColor("e5cb37");
  Color blueColor2 = HexColor("396b89");
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
