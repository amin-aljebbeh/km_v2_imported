import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../utils/utils_importer.dart';

class KammunButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final Color color;
  final Function onTap;
  final Widget child;

  const KammunButton({
    Key key,
    this.text,
    this.width,
    @required this.color,
    @required this.onTap,
    this.height,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 15.0),
      child: GestureDetector(
        onTap: onTap,
        child: new Container(
          height: height != null ? height : 40,
          width: width,
          decoration: new BoxDecoration(
              color: color,
              borderRadius: new BorderRadius.all(Radius.circular(6.0))),
          child: Center(
            child: child != null
                ? child
                : AutoSizeText(
                    text,
                    style: decisionButtonStyle,
                    maxLines: 1,
                  ),
          ),
        ),
      ),
    );
  }
}
