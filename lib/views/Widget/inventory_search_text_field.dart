import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';

class InventorySearchTextField extends StatefulWidget with PreferredSizeWidget {
  final TextEditingController controller;
  final Function onReload;
  final BuildContext context;

  const InventorySearchTextField(
      {Key key, @required this.controller, @required this.onReload, @required this.context})
      : super(key: key);
  @override
  _InventorySearchTextFieldState createState() => _InventorySearchTextFieldState();

  @override
  Size get preferredSize =>
      Size(MediaQuery.of(context).size.width * 0.8, MediaQuery.of(context).size.height * 0.07);
}

class _InventorySearchTextFieldState extends State<InventorySearchTextField> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Container(
        padding: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0) //                 <--- border radius here
                ),
            border: Border.all(color: ColorUtils.primaryColor, width: 2)),
        child: TextField(
          style: flushBarStyle,
          decoration: InputDecoration(
            suffixIcon: IconButton(
                icon: Icon(
                  Icons.close,
                  size: 20,
                  color: Colors.white,
                ),
                onPressed: () {
                  widget.controller.text = '';
                }),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: ColorUtils.kmColors),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: ColorUtils.kmColors),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: ColorUtils.kmColors),
            ),
          ),
          cursorColor: ColorUtils.kmColors,
          controller: widget.controller,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            onPressed: widget.onReload,
            icon: Icon(
              Icons.refresh,
              size: 35,
            ),
          ),
        )
      ],
    );
  }
}
