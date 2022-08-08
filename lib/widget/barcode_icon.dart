import 'package:flutter/material.dart';
import 'package:kammun_app/core/core_importer.dart';

import '../modules/barcode/view/barcode_screen.dart';

class BarcodeIcon extends StatelessWidget {
  final Function onPressed;

  const BarcodeIcon({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: ColorUtils.primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(6.0)),
        border: Border.all(color: ColorUtils.primaryColor),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: const Icon(NewIcons.qrcode, size: 20, color: Colors.white),
        onPressed: () {
          if (onPressed != null) onPressed();
          Navigator.push(
            navigatorKey.currentContext,
            MaterialPageRoute(builder: (screenContext) => const BarCodeScreen()),
          );
        },
      ),
    );
  }
}
