import 'package:flutter/material.dart';

Color primaryColor = HexColor('35637c');
Color searchGreyColor = HexColor('e6e6e6');

Color kmColors = const Color.fromARGB(255, 210, 178, 2);

Color kmColors2 = HexColor('e5cb37');
List<Color> warehousesColors = [primaryColor, kmColors, kmColors2];
List<Color> requestStatusColors = [kmColors, Colors.green, Colors.red];

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) hexColor = 'FF' + hexColor;
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
