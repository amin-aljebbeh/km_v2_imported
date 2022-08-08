import 'package:flutter/material.dart';
import 'utils_importer.dart';

TextStyle mainStyle = TextStyle(fontFamily: StringUtils.fontFamily);

TextStyle dialogStyle = mainStyle;

TextStyle decisionButtonStyle = mainStyle.copyWith(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500);

TextStyle paragraphStyle =
    mainStyle.copyWith(color: ColorUtils.primaryColor, fontSize: 18, fontWeight: FontWeight.bold);

TextStyle informationStyle = paragraphStyle.copyWith(color: Colors.black);

TextStyle flushBarStyle = mainStyle.copyWith(color: Colors.white, fontWeight: FontWeight.bold);

TextStyle naveBarStyle =
    mainStyle.copyWith(color: const Color.fromARGB(255, 53, 99, 124), fontWeight: FontWeight.w500, fontSize: 15);

TextStyle textFieldStyle = mainStyle.copyWith(fontWeight: FontWeight.w500, fontSize: 16.0, color: Colors.black);

TextStyle hintStyle = mainStyle.copyWith(color: Colors.black26, fontSize: 15);

TextStyle labelStyle = mainStyle.copyWith(fontSize: 15, color: ColorUtils.greyColor);

TextStyle disableStyle = paragraphStyle.copyWith(color: Colors.black38);

TextStyle loseStyle = mainStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18);

TextStyle homeIconStyle = mainStyle.copyWith(color: Colors.grey, fontSize: 15);

TextStyle homeActiveIconStyle = homeIconStyle.copyWith(fontWeight: FontWeight.w500, color: ColorUtils.primaryColor);

TextStyle tabStyle = mainStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15);
