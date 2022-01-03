import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/Styles.dart';

class OrderInformationRow extends StatefulWidget {
  final String rightSideText;
  final String leftSideText;
  final TextStyle leftSideStyle;
  final GestureRecognizer recognizer;

  const OrderInformationRow({
    Key key,
    @required this.rightSideText,
    @required this.leftSideText,
    @required this.leftSideStyle,
    this.recognizer,
  }) : super(key: key);

  @override
  _OrderInformationRowState createState() => _OrderInformationRowState();
}

class _OrderInformationRowState extends State<OrderInformationRow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: widget.rightSideText,
                style: paragraphStyle,
              ),
              TextSpan(
                text: widget.leftSideText,
                style: widget.leftSideStyle,
                recognizer: widget.recognizer,
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
