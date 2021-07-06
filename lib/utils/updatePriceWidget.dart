import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/products_view/services/products_services.dart';

class UpdatePriceWidget extends StatefulWidget {
  final Function(bool) onSavePressed;
  final String title;
  final TextInputType inputType;
  final String textHint;
  final String bodyKey;
  final int productId;
  final String initialText;
  final ProductData productData;
  final bool isForSubWarehouse;

  UpdatePriceWidget(
      {this.onSavePressed,
      this.initialText = "",
      this.title,
      this.inputType = TextInputType.number,
      @required this.bodyKey,
      @required this.productId,
      this.productData,
      this.isForSubWarehouse = true,
      this.textHint = "."});

  @override
  _UpdatePriceWidgetState createState() => _UpdatePriceWidgetState();
}

class _UpdatePriceWidgetState extends State<UpdatePriceWidget> {
  final _textController = TextEditingController();

  @override
  void initState() {
    _textController.text = widget.initialText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Row(
    //   children: [Text("hellow")],
    // );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          widget.title,
          overflow: TextOverflow.clip,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            fontFamily: UtilsImporter().stringUtils.HKGrotesk,
          ),
        ),
        Container(
          height: 50,
          width: 150,
          child: TextFormField(
            controller: _textController,
            textAlign: TextAlign.center,
            keyboardType: widget.inputType,
            decoration: new InputDecoration(
              hintText: widget.textHint,
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(10.0),
                borderSide: new BorderSide(),
              ),
            ),
          ),
        ),
        IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.green,
              size: 30,
            ),

            // widget.products.supplierCode != null &&
            //                 LoadingScreenServices.subSupplierCodeHint
            //                     .hasMatch(widget.products.supplierCode)
            onPressed: () async {
              Tools.logToConsole("button save clicked");
              if (widget.bodyKey == "supplier_code" &&
                  !LoadingScreenServices.subSupplierCodeHint
                      .hasMatch(_textController.text)) {
                Flushbar(
                  backgroundColor: Colors.red,
                  // titleText: Text("تمت الإضافة بنجاح"),
                  messageText: Text(
                    "فشل عملية التعديل يجب أن يحتوي رمز المادة على الرمز الخاص بك",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                  ),

                  boxShadows: [
                    BoxShadow(
                      color: UtilsImporter().colorUtils.primarycolor,
                      offset: Offset(0.0, 2.0),
                      blurRadius: 3.0,
                    )
                  ],
                  icon: Icon(
                    Icons.error,
                    size: 28.0,
                    color: Colors.white,
                  ),
                  duration: Duration(seconds: 3),
                  leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
                )..show(context);
              } else {
                Tools.logToConsole(
                    "I'm in else on save cliked ${widget.bodyKey}");

                Tools.logToConsole(
                    "I'm in else on save _textController ${_textController.text}");
                Tools.logToConsole(
                    "I'm in else on save isForSubWarehouse ${widget.isForSubWarehouse}");
                Tools.logToConsole(
                    "I'm in else on save subWarehouseId ${widget.productData.subWarehouseId != null}");

                Tools.logToConsole(
                    "I'm in else on save productId ${widget.productId}");
                bool result = await ProductsServices.updateProductsDetails(
                    bodyKey: widget.bodyKey,
                    value: _textController.text,
                    isForSubWarehouse: widget.isForSubWarehouse,
                    subWarehouseId:
                        widget.productData.subWarehouseId.toString(),
                    productId: widget.productId.toString());

                Tools.logToConsole("The Result issssss from onPresed $result");

                if (result) {
                  Flushbar(
                    backgroundColor: Colors.green,
                    // titleText: Text("تمت الإضافة بنجاح"),
                    messageText: Text(
                      "تم التعديل بنجاح",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                    ),

                    boxShadows: [
                      BoxShadow(
                        color: UtilsImporter().colorUtils.primarycolor,
                        offset: Offset(0.0, 2.0),
                        blurRadius: 3.0,
                      )
                    ],
                    icon: Icon(
                      Icons.assignment_turned_in,
                      size: 28.0,
                      color: Colors.white,
                    ),
                    duration: Duration(seconds: 1),
                    leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
                  )..show(context);
                } else {
                  Flushbar(
                    backgroundColor: Colors.red,
                    // titleText: Text("تمت الإضافة بنجاح"),
                    messageText: Text(
                      "فشل بعملية التعديل",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                    ),

                    boxShadows: [
                      BoxShadow(
                        color: UtilsImporter().colorUtils.primarycolor,
                        offset: Offset(0.0, 2.0),
                        blurRadius: 3.0,
                      )
                    ],
                    icon: Icon(
                      Icons.error,
                      size: 28.0,
                      color: Colors.white,
                    ),
                    duration: Duration(seconds: 1),
                    leftBarIndicatorColor: UtilsImporter().colorUtils.kmColors,
                  )..show(context);

                  // return result;
                }
              }
            }),
      ],
    );
  }
}
