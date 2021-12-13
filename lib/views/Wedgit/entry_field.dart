import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';

// ignore: must_be_immutable
class EntryField extends StatefulWidget {
  bool canBeEmpty;
  TextEditingController controller;
  String hint;
  TextInputType fieldType;
  bool isAddress;
  double width;
  bool isPhoneNumber;

  EntryField(
      {this.canBeEmpty = true,
      this.controller,
      this.hint,
      this.fieldType,
      this.isAddress = false,
      this.width,
      this.isPhoneNumber = false});

  @override
  _EntryFieldState createState() => _EntryFieldState();
}

class _EntryFieldState extends State<EntryField> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        width: widget.width ?? MediaQuery.of(context).size.width,
        //height: height ?? 54.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          border: Border.all(width: 1.0, color: Colors.green[700]),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.16),
                offset: Offset(0, 3.0),
                blurRadius: 6.0),
          ],
        ),
        child: TextFormField(
          onChanged: (value) {
            setState(() {});
          },
          validator: (value) {
            RegExp regExp = new RegExp("^(?:9)?[0-9]{3}(?:-)[0-9]{9}\$");

            if (value.isEmpty && !widget.canBeEmpty)
              return "This field can not be empty";
            if (widget.isPhoneNumber &&
                !regExp.hasMatch(widget.controller.text))
              return "Please make sure you enter a 9-digit number (e.g. 5503394244)";
            else
              return null;
          },
          controller: widget.controller,
          keyboardType: widget.fieldType,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: widget.hint,
            hintStyle: TextStyle(
              fontFamily: UtilsImporter().stringUtils.HKGrotesk,
            ),
            fillColor: Colors.white,
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 3.0,
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(
                  color: Color(0xFF999999),
                  width: 1.0,
                )),
            /*errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    )),*/
          ),
        ));
  }
}
