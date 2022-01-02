import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'new_utils_importer.dart';

TextStyle mainStyle = TextStyle(
  fontFamily: StringUtils.HKGrotesk,
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
  color: Color.fromARGB(255, 53, 99, 124),
  fontWeight: FontWeight.w500,
  fontSize: 15,
);

TextStyle darkBold = mainStyle.copyWith(
  fontWeight: FontWeight.w600,
  color: ColorUtils.greyColor,
  fontSize: 17.5,
);

TextStyle dropdownItemStyle = mainStyle.copyWith(
  color: Colors.black,
  fontWeight: FontWeight.w700,
);

TextStyle textFieldStyle = mainStyle.copyWith(
  fontWeight: FontWeight.w500,
  fontSize: 16.0,
  color: Colors.black,
);

TextStyle hintStyle = mainStyle.copyWith(
  color: Colors.black26,
  fontSize: 15,
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
