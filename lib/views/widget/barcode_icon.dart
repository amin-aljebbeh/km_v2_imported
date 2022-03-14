import 'package:flutter/material.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/products_view/barcode_screen.dart';
import 'package:kammun_app/views/products_view/services/products_services.dart';

import '../../Services.dart';

class BarcodeIcon extends StatelessWidget {
  final BarcodeRequestType requestType;
  final int productId;
  final Function onPressed;
  final Color color;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(String) onAddBarcode;
  final ProductData productData;

  BarcodeIcon({
    Key key,
    @required this.requestType,
    this.productId,
    this.onPressed,
    this.color,
    this.scaffoldKey,
    this.onAddBarcode,
    this.productData,
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
        bool result;
        String resultBarcode;
        if (onPressed != null) onPressed();
        Navigator.push(
          scaffoldKey.currentContext,
          MaterialPageRoute(
            builder: (screenContext) => BarCodeScreen(
              productData: productData,
              requestType: requestType,
              onIgnore: (barcode) async {
                resultBarcode =
                    await ProductsServices.setBarcodeToProduct(bareCode: int.parse(barcode), productId: productId);
                result = (resultBarcode != 'error');
                Tools.logToConsole(result);
                Services.resultFlushBar(context: context, result: result);
                onAddBarcode(resultBarcode);
              },
            ),
          ),
        );
      },
    );
  }
}
