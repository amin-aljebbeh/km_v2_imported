import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class AlertTextView extends StatelessWidget {
  final String text;
  final Color textColor;
  final double textSize = 15;
  final FontWeight textWeight;
  final Color insideBorderColor;
  final String successText;
  final Color headerTextColor;
  final double headerTextSize;
  final double messageTextSize;

  const AlertTextView(this.text, this.textColor, this.insideBorderColor, this.textWeight, this.successText,
      this.headerTextColor, this.headerTextSize, this.messageTextSize,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: insideBorderColor, width: 4),
          ),
          padding: const EdgeInsets.all(8),
          alignment: Alignment.topRight,
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: successText,
                  style: TextStyle(
                      color: headerTextColor,
                      fontSize: headerTextSize ?? 15,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                      fontFamily: StringUtils.fontFamilyHKGrotesk),
                ),
                TextSpan(
                  text: text,
                  style: TextStyle(
                      color: textColor,
                      fontSize: messageTextSize ?? textSize,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                      fontFamily: StringUtils.fontFamilyHKGrotesk),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
