import 'dart:ui';
import 'package:flutter/material.dart';

class BlurredWidget extends StatelessWidget {
  final Widget child;

  const BlurredWidget({Key key, @required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        new Center(
          child: new ClipRect(
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 0.750, sigmaY: 0.750),
              child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.grey.shade200.withOpacity(0.5)),
                child: SizedBox(
                  height: 215,
                  width: 352,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
