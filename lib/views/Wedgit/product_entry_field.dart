import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';

import 'widgets_importer.dart';

class ProductEntryField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String title;
  final TextInputType fieldType;
  final double width;

  const ProductEntryField({
    Key key,
    this.controller,
    this.hint,
    @required this.title,
    @required this.fieldType,
    this.width,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: blackBold,
        ),
        SizedBox(height: 8),
        EntryField(
          width: width,
          onSubmit: (notEmpty) {},
          isPhoneNumber: false,
          isAddress: false,
          canBeEmpty: false,
          fieldType: fieldType,
          controller: controller,
          hint: hint,
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
