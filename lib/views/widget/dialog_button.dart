import 'package:flutter/material.dart';

import '../../utils/utils_importer.dart';

class DialogButton extends StatelessWidget {
  final String text;
  final Function onTap;

  const DialogButton({Key key, @required this.text, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        text,
        style: dialogStyle,
      ),
      onPressed: onTap,
    );
  }
}
