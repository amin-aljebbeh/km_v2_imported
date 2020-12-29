import 'package:flutter/material.dart'; 
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class KammunButton extends StatelessWidget {
  final Function onPress;
  final String text;
  KammunButton({this.onPress, @required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: new Container(
        height: 50.0,
        decoration: new BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: new Text(
            text,
            style: new TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk),
          ),
        ),
      ),
    );
  }

  // return new Padding(
  //     padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0),
  //     child: showContinueShoppingButtonWithGesture);

}
