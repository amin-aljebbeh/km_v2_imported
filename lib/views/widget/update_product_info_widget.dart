import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/views/Widget/widgets_importer.dart';
import 'package:kammun_app/views/inventory/services/inventory_services.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/products_view/services/products_services.dart';

import '../../utils/utils_importer.dart';

class UpdateProductInfoWidget extends StatefulWidget {
  final Function(String) onSavePressed;
  final String title;
  final TextInputType inputType;
  final String textHint;
  final String bodyKey;
  final int productId;
  final String initialText;
  final ProductData productData;
  final bool isForSubWarehouse;
  final bool isForPriceRate;
  final int increasePercentage;
  final double priceFactor;

  UpdateProductInfoWidget({
    this.onSavePressed,
    this.initialText = "",
    this.title,
    this.inputType = TextInputType.number,
    @required this.bodyKey,
    @required this.productId,
    this.productData,
    this.isForSubWarehouse = true,
    this.textHint = ".",
    this.isForPriceRate = false,
    this.increasePercentage,
    this.priceFactor,
  });

  @override
  _UpdateProductInfoWidgetState createState() => _UpdateProductInfoWidgetState();
}

class _UpdateProductInfoWidgetState extends State<UpdateProductInfoWidget> {
  final textController = TextEditingController();

  @override
  void initState() {
    textController.text = widget.initialText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextFieldRow(
                hint: widget.textHint,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                controller: textController,
                text: widget.title,
                inputType: widget.inputType,
                width: 150,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.save,
                color: ColorUtils.kmColors,
                size: 30,
              ),
              onPressed: () async {
                if (textController.text.isNotEmpty) {
                  if (widget.bodyKey == 'discount') {
                    widget.onSavePressed('success');
                  } else {
                    if (widget.isForPriceRate) {
                      bool result = await InventoryServices.updatePriceRateThreshold(textController.text);
                      Services.resultFlushBar(context: context, result: result);
                    } else {
                      if (widget.bodyKey == "supplier_code" &&
                          !LoadingScreenServices.subSupplierCodeHint.hasMatch(textController.text)) {
                        Flushbar(
                          backgroundColor: Colors.red,
                          messageText: Text(
                            "فشل عملية التعديل يجب أن يحتوي رمز المادة على الرمز الخاص بك",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: StringUtils.fontFamilyHKGrotesk),
                          ),
                          boxShadows: [
                            BoxShadow(
                              color: ColorUtils.primaryColor,
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
                          leftBarIndicatorColor: ColorUtils.kmColors,
                        )..show(context);
                      } else {
                        String newValue = textController.text;
                        if (widget.bodyKey == 'price') {
                          double tempValue = double.parse(newValue.split('.')[0]);
                          tempValue *= widget.priceFactor;
                          tempValue += widget.increasePercentage;
                          newValue = tempValue.toString();
                        }
                        bool result = await ProductsServices.updateProductsDetails(
                            bodyKey: widget.bodyKey,
                            value: newValue,
                            isForSubWarehouse: widget.isForSubWarehouse,
                            subWarehouseId: widget.productData.subWarehouseId.toString(),
                            productId: widget.productId.toString());

                        if (result) widget.onSavePressed(textController.text);
                        Services.resultFlushBar(context: context, result: result);
                      }
                    }
                  }
                } else {
                  Toast.show("الحقل فارغ !", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                }
              },
            ),
          ],
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
