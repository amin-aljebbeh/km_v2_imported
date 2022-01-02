import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/utils/new_utils_importer.dart';

class ScreenMessage extends StatelessWidget {
  final String message;

  const ScreenMessage({Key key, @required this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 50.0,
        color: Colors.transparent,
        child: Center(
          child: Text(
            message,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: ColorUtils.greyColor,
              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
