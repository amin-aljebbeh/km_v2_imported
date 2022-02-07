import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/products_view/barcode_products.dart';
import 'package:kammun_app/views/products_view/services/products_services.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'products_view.dart';

class BarCodeScreen extends StatefulWidget {
  final int productId;
  final BarcodeRequestType requestType;
  final Function(String) onIgnore;

  const BarCodeScreen({Key key, this.productId, @required this.requestType, this.onIgnore}) : super(key: key);

  @override
  _BarCodeScreenState createState() => _BarCodeScreenState();
}

class _BarCodeScreenState extends State<BarCodeScreen> {
  String barcode;
  bool selected;

  List<ProductData> productsList = List<ProductData>();

  @override
  initState() {
    selected = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: QrCamera(
            child: widget.requestType == BarcodeRequestType.addProduct ||
                    widget.requestType == BarcodeRequestType.attachProduct
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 1,
                        ),
                        KammunButton(
                          height: 50,
                          color: ColorUtils.primaryColor,
                          onTap: () {
                            widget.onIgnore('');
                          },
                          text: 'الإضافة بدون كود',
                        ),
                      ],
                    ),
                  )
                : Container(),
            onError: (context, error) => Text(
              error.toString(),
              style: TextStyle(color: Colors.red),
            ),
            qrCodeCallback: (code) {
              setState(() async {
                barcode = code;
                if (barcode != null) {
                  switch (widget.requestType) {
                    case BarcodeRequestType.search:
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => new ProductsView(
                            barcode: barcode,
                            categoryId: "0",
                          ),
                        ),
                      );
                      break;
                    case BarcodeRequestType.addBarcode:
                    case BarcodeRequestType.addProduct:
                    case BarcodeRequestType.attachProduct:
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => new BarcodeProducts(
                            onIgnore: (barcode) => widget.onIgnore(barcode),
                            requestType: widget.requestType,
                            barcode: barcode,
                          ),
                        ),
                      );
                      break;
                  }
                }
              });
            },
          ),
        ),
      ),
    );
  }
}
