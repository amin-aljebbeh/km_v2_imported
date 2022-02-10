import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/products_view/barcode_screen.dart';

class BarcodeIcon extends StatelessWidget {
  final int productId;
  final Function onPressed;
  final Color color;
  final GlobalKey<ScaffoldState> scaffoldKey;

  BarcodeIcon({
    Key key,
    this.productId,
    this.onPressed,
    this.color,
    this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        BareCodeIcon.barcode_2,
        size: 30,
        color: color,
      ),
      onPressed: () {
        if (onPressed != null) onPressed();
        Navigator.push(
          scaffoldKey.currentContext,
          MaterialPageRoute(
            builder: (screenContext) => BarCodeScreen(),
          ),
        );
      },
    );
  }
}
