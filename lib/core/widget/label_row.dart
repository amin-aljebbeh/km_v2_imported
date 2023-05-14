import 'package:flutter/gestures.dart';

import '../core_importer.dart';

class LabelRow extends StatefulWidget {
  final String rightSideText;
  final String leftSideText;
  final TextStyle leftSideStyle;
  final GestureRecognizer recognizer;

  const LabelRow({
    Key key,
    @required this.rightSideText,
    @required this.leftSideText,
    @required this.leftSideStyle,
    this.recognizer,
  }) : super(key: key);

  @override
  _LabelRowState createState() => _LabelRowState();
}

class _LabelRowState extends State<LabelRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(text: widget.rightSideText, style: paragraphStyle),
            TextSpan(text: widget.leftSideText, style: widget.leftSideStyle, recognizer: widget.recognizer),
          ],
        ),
      ),
    );
  }
}
