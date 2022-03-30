import 'package:flutter/material.dart';

import 'utils_importer.dart';

TextStyle mainStyle = TextStyle(
  fontFamily: StringUtils.fontFamilyHKGrotesk,
);

TextStyle dialogStyle = mainStyle;

TextStyle decisionButtonStyle = mainStyle.copyWith(
  color: Colors.white,
  fontSize: 20.0,
  fontWeight: FontWeight.w500,
);

TextStyle paragraphStyle = mainStyle.copyWith(
  color: ColorUtils.primaryColor,
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

TextStyle informationStyle = paragraphStyle.copyWith(
  color: Colors.black,
);

TextStyle flushBarStyle = mainStyle.copyWith(
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

TextStyle naveBarStyle = mainStyle.copyWith(
  color: const Color.fromARGB(255, 53, 99, 124),
  fontWeight: FontWeight.w500,
  fontSize: 15,
);

TextStyle darkBold = mainStyle.copyWith(
  color: ColorUtils.primaryColor,
  fontSize: 17,
);

TextStyle dropdownItemStyle = mainStyle.copyWith(
  color: Colors.black,
  fontWeight: FontWeight.w700,
);

TextStyle labelStyle = mainStyle.copyWith(
  fontSize: 15,
  color: ColorUtils.greyColor,
);

TextStyle disableStyle = paragraphStyle.copyWith(
  color: Colors.black38,
);
TextStyle warehouseStyle = mainStyle.copyWith(
  fontWeight: FontWeight.bold,
  color: ColorUtils.greyColor,
  fontSize: 20,
);
TextStyle profitStyle = warehouseStyle.copyWith(
  color: Colors.green,
  fontSize: 25,
);
TextStyle loseStyle = warehouseStyle.copyWith(
  color: Colors.red,
  fontSize: 25,
);

TextStyle userNameStyle = mainStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 15);

TextStyle blackBold = flushBarStyle.copyWith(
  color: Colors.black,
);

TextStyle worningStyle = paragraphStyle.copyWith(
  color: Colors.red,
);
