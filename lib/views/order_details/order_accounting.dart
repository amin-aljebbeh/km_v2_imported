import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/views/Wedgit/text_field_row.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/reports/services/reports_services.dart';
import '../../Services.dart';
import 'full_screen_image.dart';
import 'services/order_details_services.dart';

class OrderAccounting extends StatefulWidget {
  final int orderId;
  final List<OrderProducts> ordersAry;
  final OrdersOriginalData orderData;

  const OrderAccounting({
    Key key,
    @required this.ordersAry,
    @required this.orderId,
    @required this.orderData,
  }) : super(key: key);

  @override
  _OrderAccountingState createState() => _OrderAccountingState();
}

class _OrderAccountingState extends State<OrderAccounting> {
  List<Widget> subWarehouseTotal = [];
  List<Widget> imageWidgets = [];

  getImages() {
    for (int i = 0; i < widget.orderData.images.length; i++) {
      imageWidgets.add(
        InkWell(
          onLongPress: () async {
            List<DialogButton> dialogButtons = [
              DialogButton(
                text: StringUtils.yes,
                onTap: () async {
                  Navigator.of(context).pop();
                  bool result = await OrderDetailsServices.deleteImageFromOrder(
                    imageId: widget.orderData.images[i].id.toString(),
                  );
                  Services.resultFlushBar(
                    context: context,
                    result: result,
                  );
                  if (result)
                    setState(
                      () {
                        widget.orderData.images.removeWhere(
                          (image) => image.id == widget.orderData.images[i].id,
                        );
                        imageWidgets.clear();
                      },
                    );
                },
              ),
              DialogButton(
                text: StringUtils.no,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ];
            showMyDialog(
                title: '', context: context, text: 'هل تريد حذف الفاتورة ؟', dialogButtons: dialogButtons);
          },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return FullScreenImage(
                    imageUrl: LoadingScreenServices.imagePrefixUrl +
                        'orders/' +
                        widget.orderData.images[i].imageFileName,
                    tag: "generate_a_unique_tag",
                  );
                },
              ),
            );
          },
          child: widget.orderData.images != null && widget.orderData.images.length > 0
              ? KCacheImage(
                  tag: i + 100,
                  image:
                      LoadingScreenServices.imagePrefixUrl + 'orders/' + widget.orderData.images[i].imageFileName)
              : AssetImage("assets/kmIcon.png"),
        ),
      );
    }
  }

  _calculate() {
    setState(
      () {
        subWarehouseTotal.clear();
        subWarehouseTotal.add(
          KTableRow(
            children: [
              KTableElement(text: 'المورد'),
              KTableElement(text: 'الدفع للمورد'),
              KTableElement(text: 'السعر الصافي'),
            ],
          ),
        );
        for (int i = 0; i < widget.orderData.orderAccountingRows.length; i++) {
          subWarehouseTotal.add(
            KTableRow(
              children: [
                KTableElement(
                  text: widget.orderData.orderAccountingRows[i].subWarehouseName,
                ),
                KTableElement(
                  text: StringUtils().oCcy.format(
                        Services.kRound(widget.orderData.orderAccountingRows[i].payToSubWarehouse),
                      ),
                ),
                KTableElement(
                  text: StringUtils().oCcy.format(
                        widget.orderData.orderAccountingRows[i].netPrice,
                      ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _calculate();
    if (widget.orderData.images != null) getImages();
    return Scaffold(
      body: SafeArea(
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: subWarehouseTotal,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              child: GridView(
                scrollDirection: Axis.vertical,
                primary: false,
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 0, right: 0, top: 4, bottom: 4),
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2,
                ),
                children: imageWidgets,
              ),
            ),
            AddImageWidget(
              hasImage: widget.orderData.images != null,
              onSubmit: (image) async {
                bool result =
                    await OrderDetailsServices.addImageToOrder(image: image, orderId: widget.orderId.toString());
                Services.resultFlushBar(context: context, result: result);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 1,
                ),
                Services.isOperationManager()
                    ? KammunButton(
                        color: ColorUtils.kmColors,
                        onTap: () {
                          if (widget.orderData.shopper != null) {
                            final moneyController = TextEditingController();
                            final descriptionController = TextEditingController();
                            bool completeData() {
                              return moneyController.text.isNotEmpty && descriptionController.text.isNotEmpty;
                            }

                            List<DialogButton> decisionButtons = [
                              DialogButton(
                                text: StringUtils.addDeduct,
                                onTap: () async {
                                  if (!completeData()) {
                                    Toast.show("يرجى إدخال كافة البيانات", context,
                                        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                                  } else {
                                    Navigator.of(context).pop();
                                    bool result = await ReportsServices.addTransaction(
                                      shopperId: widget.orderData.shopper.id.toString(),
                                      transactionTypeId: LoadingScreenServices.transactionTypes
                                          .firstWhere((transactionType) => transactionType.slug == 'deduct')
                                          .id
                                          .toString(),
                                      value: moneyController.text,
                                      description: descriptionController.text,
                                      orderId: widget.orderId.toString(),
                                    );
                                    Services.resultFlushBar(context: context, result: result);
                                  }
                                },
                              ),
                              DialogButton(
                                text: StringUtils.close,
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ];
                            showMyDialog(
                              title: StringUtils.addDeduct,
                              dialogButtons: decisionButtons,
                              content: Column(
                                children: [
                                  TextFieldRow(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    controller: moneyController,
                                    text: 'المبلغ :',
                                    inputType: TextInputType.number,
                                    width: 150,
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  TextFieldRow(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    controller: descriptionController,
                                    text: 'الوصف :',
                                    inputType: TextInputType.multiline,
                                    width: MediaQuery.of(context).size.width * 0.5,
                                  ),
                                ],
                              ),
                              context: context,
                            );
                          } else {
                            Toast.show("هذا الطلب غير مسند لمتسوق", context,
                                duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                          }
                        },
                        text: StringUtils.addDeduct,
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 50,
                      )
                    : Container(),
                SizedBox(
                  width: 1,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
