import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';

// ignore: must_be_immutable
class AlertMessages extends StatelessWidget {
  String text;
  final String messageType;
  FontWeight textWeight = FontWeight.normal;
  String headerText = " ";
  Color textColor = Colors.black;
  Color outsideBorderColor = Color.fromRGBO(61, 49, 19, 1);
  Color insideBorderColor = Color.fromARGB(255, 246, 233, 181);
  Color headerTextColor = Colors.green[800];
  double headerTextSize = 15;
  double messageTextSize = 13;

  AlertMessages({
    @required this.text,
    @required this.messageType,
    this.headerText,
    this.headerTextColor,
  });

  void selectListItem(BuildContext ctx) {
    if (messageType == "invalidNumber") {
      this.outsideBorderColor = Color.fromRGBO(220, 53, 69, 1);
      this.insideBorderColor = Colors.white;
      this.textColor = Colors.black;
      this.textWeight = FontWeight.w600;
      this.headerText = headerText + "\n";
      this.headerTextColor = Color.fromRGBO(220, 53, 69, 1);
      this.headerTextSize = 22;
      this.messageTextSize = 15;
    }
    if (messageType == "internetError") {
      this.outsideBorderColor = Colors.red[800];
      this.insideBorderColor = Colors.red[100];
      this.textColor = Colors.grey[800];
      this.textWeight = FontWeight.w700;
      this.headerText = headerText + "\n";
      this.headerTextColor = Colors.red[800];
      this.headerTextSize = 17;
      this.messageTextSize = 15;
    }

    if (messageType == "green") {
      this.outsideBorderColor = Color.fromRGBO(191, 228, 193, 1);
      this.insideBorderColor = Color.fromRGBO(225, 247, 228, 1);
      this.textColor = Colors.black;
      this.textWeight = FontWeight.w700;
      this.headerText = headerText + "\n";
    }

    if (messageType.contains("Successfully")) {
      this.outsideBorderColor = Color.fromRGBO(191, 228, 193, 1);
      this.insideBorderColor = Color.fromRGBO(225, 247, 228, 1);
      this.textWeight = FontWeight.w600;
      this.headerText = headerText + "\n";
      this.headerTextColor = Colors.green[800];
    }

    if (messageType.contains("Feedback")) {
      this.outsideBorderColor = Color.fromRGBO(191, 228, 193, 1);
      this.insideBorderColor = Color.fromRGBO(225, 247, 228, 1);
      this.textColor = Colors.green[900];
      this.textWeight = FontWeight.w700;
      if (headerText.isNotEmpty) {
        this.headerText = headerText + "\n";
      } else
        this.headerText = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    selectListItem(context);
    return Container(
      margin: const EdgeInsets.only(
        top: 20.0,
        bottom: 5,
        right: 10,
        left: 10,
      ),
      decoration: myBoxDecoration(), //       <--- BoxDecoration here
      child: AlertTextView(
        text,
        textColor,
        insideBorderColor,
        textWeight,
        headerText,
        headerTextColor,
        headerTextSize,
        messageTextSize,
      ),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(3.0)),
      border: Border.all(
        color: outsideBorderColor, //                   <--- border color
        width: 1,
      ),
    );
  }
}

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

  AlertTextView(this.text, this.textColor, this.insideBorderColor, this.textWeight, this.successText,
      this.headerTextColor, this.headerTextSize, this.messageTextSize);

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
                        fontSize: headerTextSize != null ? headerTextSize : 15,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                        fontFamily: StringUtils.fontFamilyHKGrotesk),
                  ),
                  TextSpan(
                    text: text,
                    style: TextStyle(
                        color: textColor,
                        fontSize: messageTextSize != null ? messageTextSize : textSize,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                        fontFamily: StringUtils.fontFamilyHKGrotesk),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
