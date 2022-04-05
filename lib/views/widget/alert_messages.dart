import 'package:flutter/material.dart';
import 'package:kammun_app/utils/colors_utils.dart';

import 'alert_text_view.dart';

// ignore: must_be_immutable
class AlertMessages extends StatelessWidget {
  final String text;
  final String messageType;
  FontWeight textWeight = FontWeight.normal;
  String headerText = " ";
  Color textColor = Colors.black;
  Color outsideBorderColor = const Color.fromRGBO(61, 49, 19, 1);
  Color insideBorderColor = const Color.fromARGB(255, 246, 233, 181);
  Color headerTextColor = Colors.green[800];
  double headerTextSize = 15;
  double messageTextSize = 13;

  AlertMessages({
    Key key,
    @required this.text,
    @required this.messageType,
    this.headerText,
    this.headerTextColor,
    this.headerTextSize,
    this.messageTextSize,
  }) : super(key: key);

  void selectListItem(BuildContext ctx) {
    if (messageType == "invalidNumber") {
      outsideBorderColor = const Color.fromRGBO(220, 53, 69, 1);
      insideBorderColor = Colors.white;
      textColor = Colors.black;
      textWeight = FontWeight.w600;
      headerText = headerText + "\n";
      headerTextColor = const Color.fromRGBO(220, 53, 69, 1);
      headerTextSize = 22;
      messageTextSize = 15;
    }
    if (messageType == "internetError") {
      outsideBorderColor = Colors.red[800];
      insideBorderColor = Colors.red[100];
      textColor = Colors.grey[800];
      textWeight = FontWeight.w700;
      headerText = headerText + "\n";
      headerTextColor = Colors.red[800];
      headerTextSize = 17;
      messageTextSize = 15;
    }

    if (messageType == "green") {
      outsideBorderColor = ColorUtils.vegetableColor;
      insideBorderColor = const Color.fromRGBO(225, 247, 228, 1);
      textColor = Colors.black;
      textWeight = FontWeight.w700;
      headerText = headerText + "\n";
    }

    if (messageType.contains("Successfully")) {
      outsideBorderColor = ColorUtils.vegetableColor;
      insideBorderColor = const Color.fromRGBO(225, 247, 228, 1);
      textWeight = FontWeight.w600;
      headerText = headerText + "\n";
      headerTextColor = Colors.green[800];
    }

    if (messageType.contains("Feedback")) {
      outsideBorderColor = ColorUtils.vegetableColor;
      insideBorderColor = const Color.fromRGBO(225, 247, 228, 1);
      textColor = Colors.green[900];
      textWeight = FontWeight.w700;
      if (headerText.isNotEmpty) {
        headerText = headerText + "\n";
      } else {
        headerText = "";
      }
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
      borderRadius: const BorderRadius.all(Radius.circular(3.0)),
      border: Border.all(
        color: outsideBorderColor, //                   <--- border color
        width: 1,
      ),
    );
  }
}
