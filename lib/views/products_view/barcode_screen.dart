import 'package:flutter/material.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/kammun_button.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/products_view/services/products_services.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class BarCodeScreen extends StatefulWidget {
  final int productId;
  final BarcodeRequestType requestType;

  const BarCodeScreen({Key key, @required this.productId, @required this.requestType}) : super(key: key);

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
          child: widget.requestType == BarcodeRequestType.add ||
                  (widget.requestType == BarcodeRequestType.search && !selected)
              ? Expanded(
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
                            color: barcode != null ? ColorUtils.primaryColor : ColorUtils.searchGreyColor,
                            onTap: () async {
                              if (barcode != null) {
                                switch (widget.requestType) {
                                  case BarcodeRequestType.add:
                                    bool result = await ProductsServices.setBarcodeToProduct(
                                        bareCode: int.parse(barcode), productId: widget.productId);
                                    Services.resultFlushBar(context: context, result: result);
                                    break;
                                  case BarcodeRequestType.search:
                                    productsList =
                                        await ProductsServices.searchProductByBarcode(bareCode: barcode);
                                    productsList.forEach((element) {
                                      Tools.logToConsole('element.name');
                                      Tools.logToConsole(element.name);
                                      setState(() {
                                        selected = true;
                                      });
                                    });
                                    break;
                                }
                              }
                            },
                            text: /*qr == null ?*/ 'إرسال الكود' /*: qr*/,
                          ),
                        ],
                      ),
                    ),
                    onError: (context, error) => Text(
                      error.toString(),
                      style: TextStyle(color: Colors.red),
                    ),
                    qrCodeCallback: (code) {
                      setState(() {
                        barcode = code;
                      });
                    },
                  ),
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  primary: false,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: productsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => () {},
                      child: InventoryProductsViewCard(
                        onDelete: (result) {
                          if (result) {
                            setState(() {
                              productsList.removeAt(index);
                            });
                          }
                        },
                        productData: productsList[index],
                        onChangeStatus: (result) {
                          if (result) {
                            setState(() {
                              if (productsList[index].isActive == "1") {
                                productsList[index].isActive = "0";
                              } else {
                                productsList[index].isActive = "1";
                              }
                            });
                          }
                        },
                        supplierCode: productsList[index].supplierCode,
                        productId: productsList[index].id.toString(),
                        active: int.parse(productsList[index].isActive),
                        img: productsList[index].images.length > 0
                            ? LoadingScreenServices.imagePrefixUrl + productsList[index].images[0].imageFileName
                            : "",
                        productName: productsList[index].name,
                        quantity: productsList[index].unit.toString() != "null"
                            ? productsList[index].quantity.toString() + " " + productsList[index].unit.toString()
                            : productsList[index].quantity.toString(),
                        price: int.parse(productsList[index].price.split(".")[0]),
                        index: index,
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
