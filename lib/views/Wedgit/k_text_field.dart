import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/Styles.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class KTextField extends StatefulWidget {
  final TextEditingController controller;
  final int maxLine;
  final FocusNode focusNode;
  final Function onSubmitted;
  final String hintText;
  final String labelText;

  const KTextField({
    Key key,
    @required this.controller,
    @required this.maxLine,
    @required this.focusNode,
    @required this.onSubmitted,
    @required this.hintText,
    @required this.labelText,
  }) : super(key: key);

  @override
  _KTextFieldState createState() => _KTextFieldState();
}

class _KTextFieldState extends State<KTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
      child: new AutoSizeTextField(
        cursorColor: UtilsImporter().colorUtils.kmColors,
        controller: widget.controller,
        maxLines: widget.maxLine,
        focusNode: widget.focusNode,
        textInputAction: TextInputAction.next,
        autofocus: true,
        onSubmitted: widget.onSubmitted,
        onChanged: (v) {
          setState(() {});
        },
        style: textFieldStyle,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: hintStyle,
          labelText: widget.labelText,
          labelStyle: labelStyle,
          border: new UnderlineInputBorder(
            borderSide:
                new BorderSide(color: UtilsImporter().colorUtils.primaryColor),
          ),
        ),
      ),
    );
  }
}
