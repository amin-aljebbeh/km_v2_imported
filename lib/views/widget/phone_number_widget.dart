import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/widget/label_row.dart';

class PhoneNumberWidget extends StatelessWidget {
  final String phoneNumber;
  final String userName;
  final Function(String) onChoose;

  PhoneNumberWidget({Key key, this.phoneNumber, this.userName = ' ', this.onChoose}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            thickness: 1,
            color: ColorUtils.kmColors,
          ),
          LabelRow(
              rightSideText: StringUtils.phoneNumber, leftSideText: phoneNumber, leftSideStyle: informationStyle),
          LabelRow(rightSideText: StringUtils.name + " ", leftSideText: userName, leftSideStyle: informationStyle),
          Divider(
            thickness: 1,
            color: ColorUtils.kmColors,
          ),
        ],
      ),
    );
  }
}
