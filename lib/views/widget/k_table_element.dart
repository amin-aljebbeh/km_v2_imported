import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class KTableElement extends StatelessWidget {
  final String text;
  final TextStyle style;

  const KTableElement({Key key, @required this.text, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Text(
          text,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
          style: style == null ? mainStyle : style,
        ),
      ),
    );
  }
}
