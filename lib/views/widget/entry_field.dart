import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class EntryField extends StatefulWidget {
  final bool canBeEmpty;
  final TextEditingController controller;
  final String hint;
  final double width;
  final bool isPhoneNumber;
  final Function(bool) onSubmit;

  const EntryField({Key key,
    this.canBeEmpty = true,
    this.controller,
    this.hint,
    this.width,
    this.isPhoneNumber = false,
    this.onSubmit,
  }) : super(key: key);

  @override
  _EntryFieldState createState() => _EntryFieldState();
}

class _EntryFieldState extends State<EntryField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: widget.width ?? MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
        border: Border.all(width: 1.0, color: ColorUtils.kmColors),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.16), offset: const Offset(0, 3.0), blurRadius: 6.0),
        ],
      ),
      child: TextFormField(
        onChanged: (value) {
          setState(() {});
        },
        onFieldSubmitted: (string) {
          widget.onSubmit(string.isNotEmpty);
        },
        validator: (value) {
          RegExp regExp = RegExp("^(?:9)?[0-9]{3}(?:-)[0-9]{9}\$");

          if (value.isEmpty && !widget.canBeEmpty) return "This field can not be empty";
          if (widget.isPhoneNumber && !regExp.hasMatch(widget.controller.text)) {
            return "Please make sure you enter a 9-digit number (e.g. 5503394244)";
          } else {
            return null;
          }
        },
        controller: widget.controller,
        keyboardType: TextInputType.text,
        maxLines: null,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: widget.hint,
          hintStyle: TextStyle(
            fontFamily: StringUtils.fontFamilyHKGrotesk,
          ),
          fillColor: Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 3.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(
              color: Color(0xFF999999),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
