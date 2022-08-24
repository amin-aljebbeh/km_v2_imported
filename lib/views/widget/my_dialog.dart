import 'package:flutter/material.dart';

import '../../utils/utils_importer.dart';

class MyDialog extends StatelessWidget {
  final String title;
  final String text;
  final Widget content;
  final List<Widget> decisionButtons;

  const MyDialog({Key key, @required this.title, this.text, @required this.decisionButtons, this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(title, style: dialogStyle),
        content: text != null ? Text(text, style: dialogStyle) : content,
        actions: decisionButtons,
        scrollable: true);
  }
}

showMyDialog(
    {@required String title, String text, List<Widget> dialogButtons, Widget content, @required BuildContext context}) {
  showDialog(
    context: context,
    builder: (BuildContext context) =>
        MyDialog(title: title, text: text, decisionButtons: dialogButtons, content: content),
  );
}
