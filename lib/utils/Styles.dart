import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'utils_importer.dart';

TextStyle mainStyle = TextStyle(
  fontFamily: UtilsImporter().stringUtils.HKGrotesk,
);

TextStyle dialogStyle = mainStyle;

TextStyle decisionButtonStyle = mainStyle.copyWith(
  color: Colors.white,
  fontSize: 20.0,
  fontWeight: FontWeight.w500,
);

TextStyle paragraphStyle = mainStyle.copyWith(
  color: UtilsImporter().colorUtils.primarycolor,
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
  color: UtilsImporter().colorUtils.greycolor,
  fontSize: 17.5,
);

TextStyle dropdownItemStyle = TextStyle(
  fontWeight: FontWeight.w700,
  fontFamily: UtilsImporter().stringUtils.HKGrotesk,
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
  fontSize: 25,
  color: UtilsImporter().colorUtils.greycolor,
  fontFamily: UtilsImporter().stringUtils.HKGrotesk,
);
