import 'package:flutter/gestures.dart';

import '../core_importer.dart';

class LabelRow extends StatelessWidget {
  final String rightSideText;
  final String leftSideText;
  final TextStyle leftSideStyle;
  final Function onTap;

//todo restore the old way
  const LabelRow({
    Key key,
    @required this.rightSideText,
    @required this.leftSideText,
    @required this.leftSideStyle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(text: rightSideText, style: paragraphStyle),
            TextSpan(
                text: leftSideText,
                style: leftSideStyle,
                recognizer: TapGestureRecognizer()..onTap = () => onTap != null ? onTap() : {}),
          ],
        ),
      ),
    );
  }
}
