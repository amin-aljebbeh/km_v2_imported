import 'package:flutter/material.dart';

import '../../utils/Styles.dart';
import 'dialog_button.dart';

class MyDialog extends StatelessWidget {
  final String title;
  final String text;
  final Widget content;
  final List<DialogButton> decisionButtons;

  const MyDialog({
    Key key,
    @required this.title,
    this.text,
    @required this.decisionButtons,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: dialogStyle,
      ),
      content: text != null
          ? Text(
              text,
              style: dialogStyle,
            )
          : content,
      actions: decisionButtons,
      scrollable: true,
    );
  }
}

showMyDialog(
    {@required String title,
    String text,
    List<DialogButton> dialogButtons,
    Widget content,
    @required BuildContext context}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return MyDialog(
        title: title,
        text: text,
        decisionButtons: dialogButtons,
        content: content,
      );
    },
  );
}
