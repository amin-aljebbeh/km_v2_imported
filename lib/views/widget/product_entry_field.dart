import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';

import 'widgets_importer.dart';

class ProductEntryField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String title;
  final double width;
  final GlobalKey<FormState> formKey;

  const ProductEntryField({
    Key key,
    this.controller,
    this.hint,
    @required this.title,
    this.width,
    this.formKey,
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
          formKey: formKey,
          width: width,
          onSubmit: (notEmpty) {},
          hint: hint,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
