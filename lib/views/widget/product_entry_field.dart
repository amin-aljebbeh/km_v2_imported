import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';

import 'widgets_importer.dart';

class ProductEntryField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String title;
  final double width;

  const ProductEntryField({
    // reorder in add product view
    Key key,
    this.controller,
    this.hint,
    @required this.title,
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
        const SizedBox(height: 8),
        EntryField(
          controller: controller,
          width: width,
          onSubmit: (notEmpty) {},
          hint: hint,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
