import 'package:flutter/material.dart';
import 'package:kammun_app/core/core_importer.dart';

class KTextField extends StatefulWidget {
  final TextEditingController controller;
  final int maxLines;
  final FocusNode focusNode;
  final Function onSubmitted;
  final Function onChanged;
  final String hintText;
  final bool autoFocus;
  final bool enabled;

  const KTextField({
    Key key,
    @required this.controller,
    this.maxLines = 1,
    this.focusNode,
    @required this.onSubmitted,
    @required this.hintText,
    this.autoFocus = false,
    this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  _KTextFieldState createState() => _KTextFieldState();
}

class _KTextFieldState extends State<KTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, widget.autoFocus ? 25.0 : 0, 0.0, 0.0),
      child: TextField(
        cursorColor: Colors.black,
        enabled: widget.enabled,
        controller: widget.controller,
        maxLines: widget.maxLines,
        focusNode: widget.focusNode,
        textInputAction: TextInputAction.next,
        autofocus: widget.autoFocus,
        onSubmitted: (string) => widget.onSubmitted(),
        onChanged: (v) {
          if (widget.autoFocus) {
            setState(() {});
          }
          if (widget.onChanged != null) {
            widget.onChanged();
          }
        },
        style: textFieldStyle,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: hintStyle,
          labelStyle: labelStyle.copyWith(fontSize: 25),
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(color: ColorUtils.searchGreyColor, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide(color: ColorUtils.searchGreyColor, width: 2.0),
          ),
        ),
      ),
    );
  }
}
