import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/products_view/services/products_services.dart';
import 'package:kammun_app/utils/utils_importer.dart';

import '../../utils/Styles.dart';
import 'entry_field.dart';

class UpdateProductInfoWidget extends StatefulWidget {
  final Function(bool) onSavePressed;
  final String title;
  final TextInputType inputType;
  final String textHint;
  final String bodyKey;
  final int productId;
  final String initialText;
  final ProductData productData;
  final bool isForSubWarehouse;

  UpdateProductInfoWidget(
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
  _UpdateProductInfoWidgetState createState() =>
      _UpdateProductInfoWidgetState();
}

class _UpdateProductInfoWidgetState extends State<UpdateProductInfoWidget> {
  final _textController = TextEditingController();

  @override
  void initState() {
    _textController.text = widget.initialText;
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
            Text(
              widget.title,
              overflow: TextOverflow.clip,
              style: paragraphStyle,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EntryField(
                  controller: _textController,
                  fieldType: widget.inputType,
                  hint: widget.textHint,
                  width: 150,
                  canBeEmpty: false,
                  isAddress: false,
                  isPhoneNumber: false,
                ),
                // Container(
                //   child: AutoSizeTextField(
                //     maxLines: null,
                //     textAlign: TextAlign.center,
                //     decoration: new InputDecoration(
                //       hintStyle: hintStyle,
                //       fillColor: Colors.white,
                //       border: new UnderlineInputBorder(
                //         borderSide: new BorderSide(
                //             color: ColorUtils.primarycolor),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  width: 18,
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
                                fontFamily: StringUtils.HKGrotesk),
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
                        bool result =
                            await ProductsServices.updateProductsDetails(
                                bodyKey: widget.bodyKey,
                                value: _textController.text,
                                isForSubWarehouse: widget.isForSubWarehouse,
                                subWarehouseId: widget
                                    .productData.subWarehouseId
                                    .toString(),
                                productId: widget.productId.toString());

                        Tools.logToConsole(
                            "The Result issssss from onPresed $result");
                        Services.resultFlushBar(
                            context: context, result: result);
                      }
                    }),
              ],
            ),
          ],
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
