import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/products_view/services/products_services.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'products_view.dart';

class BarCodeScreen extends StatefulWidget {
  final int productId;
  final BarcodeRequestType requestType;

  const BarCodeScreen(
      {Key key, @required this.productId, @required this.requestType})
      : super(key: key);

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
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 1,
                  ),
                  KammunButton(
                    height: 50,
                    color: barcode != null
                        ? ColorUtils.primaryColor
                        : ColorUtils.searchGreyColor,
                    onTap: () async {
                      if (barcode != null) {
                        switch (widget.requestType) {
                          case BarcodeRequestType.add:
                            bool result =
                                await ProductsServices.setBarcodeToProduct(
                                    bareCode: int.parse(barcode),
                                    productId: widget.productId);
                            Services.resultFlushBar(
                                context: context, result: result);
                            break;
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
                        }
                      }
                    },
                    text: 'إرسال الكود',
                  ),
                ],
              ),
            ),
            onError: (context, error) => Text(
              error.toString(),
              style: TextStyle(color: Colors.red),
            ),
            qrCodeCallback: (code) {
              Toast.show("تم التقاط كود جديد", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
              setState(() {
                barcode = code;
              });
            },
          ),
        ),
      ),
    );
  }
}
