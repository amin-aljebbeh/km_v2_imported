import 'package:flutter/material.dart';
import 'package:kammun_app/utils/Styles.dart';

class KTableElement extends StatelessWidget {
  final String text;

  const KTableElement({Key key, @required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: mainStyle,
      ),
    );
  }
}
