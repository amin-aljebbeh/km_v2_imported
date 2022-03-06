import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/reports/add_transaction_view.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';

import '../../Services.dart';
import 'full_screen_image.dart';
import 'services/order_details_services.dart';

class OrderAccounting extends StatefulWidget {
  final OrdersOriginalData orderData;
  final Function onDelete;

  const OrderAccounting({
    Key key,
    @required this.orderData,
    this.onDelete,
  }) : super(key: key);

  @override
  _OrderAccountingState createState() => _OrderAccountingState();
}

class _OrderAccountingState extends State<OrderAccounting> {
  double distance;
  List<Widget> subWarehouseTotal = [];
  List<InkWell> imageWidgets = [];
  List<OrderImage> images = [];

  @override
  void initState() {
    if (widget.orderData.images.isNotEmpty) images.addAll(widget.orderData.images);
    super.initState();
  }

  getImages() {
    for (int i = 0; i < images.length; i++) {
      imageWidgets.add(
        InkWell(
          onLongPress: () async {
            List<DialogButton> dialogButtons = [
              DialogButton(
                text: StringUtils.yes,
                onTap: () async {
                  Navigator.of(context).pop();
                  bool result = await OrderDetailsServices.deleteImageFromOrder(
                    imageId: images[i].id.toString(),
                  );
                  Services.resultFlushBar(
                    context: context,
                    result: result,
                  );
                  if (result)
                    setState(() {
                      widget.orderData.images.removeWhere(
                        (image) => image.id == widget.orderData.images[i].id,
                      );
                      images.clear();
                      images.addAll(widget.orderData.images);
                      widget.onDelete();
                    });
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
                  tag: widget.orderData.images[i].imageFileName,
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
          if (widget.orderData.orderAccountingRows[i].payToSubWarehouse != 0)
            subWarehouseTotal.add(KTableRow(
              children: [
                KTableElement(
                  text: widget.orderData.orderAccountingRows[i].subWarehouseName,
                ),
                KTableElement(
                  text: StringUtils().oCcy.format(
                        widget.orderData.orderAccountingRows[i].directDiscount == 1
                            ? Services.kRound(widget.orderData.orderAccountingRows[i].payToSubWarehouse)
                            : widget.orderData.orderAccountingRows[i].payToSubWarehouse,
                      ),
                ),
                KTableElement(
                  text: StringUtils().oCcy.format(
                        widget.orderData.orderAccountingRows[i].netPrice,
                      ),
                ),
              ],
            ));
        }
        int delivery = int.parse(widget.orderData.supportedCityCost.split('.')[0]) +
            int.parse(widget.orderData.deliveryCost.split('.')[0]);
        int subTotal = int.parse(widget.orderData.total.split(".")[0]) - delivery;
        subWarehouseTotal.add(KTableRow(
          children: [
            KTableElement(text: StringUtils.subtotal),
            KTableElement(text: subTotal.toString()),
          ],
        ));
        subWarehouseTotal.add(KTableRow(
          children: [
            KTableElement(text: "أجور التوصيل"),
            KTableElement(text: delivery.toString()),
          ],
        ));
        subWarehouseTotal.add(KTableRow(
          children: [
            KTableElement(text: StringUtils.total),
            KTableElement(text: widget.orderData.total.split(".")[0]),
          ],
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    distance = MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height * 0.25);
    _calculate();
    if (widget.orderData.images != null) getImages();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
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
                SizedBox(
                  height: 100,
                ),
              ],
            ),
            Positioned(
              top: MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height * 0.71),
              right: MediaQuery.of(context).size.width * 0.05,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 1,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 1,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: AddImageWidget(
                                onSubmit: (image) async {
                                  bool result = await OrderDetailsServices.addImageToOrder(
                                      image: image, orderId: widget.orderData.id.toString());
                                  Services.resultFlushBar(context: context, result: result);
                                  setState(() {});
                                },
                              ),
                            ),
                            SizedBox(
                              width: 1,
                            ),
                          ],
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
                                      if (widget.orderData.shopper == null) {
                                        Toast.show("هذا الطلب غير مسند لمتسوق", context,
                                            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddTransactionView(
                                              orderId: widget.orderData.id,
                                              shopperName: widget.orderData.shopper.name,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    text: StringUtils.addTransaction,
                                    width: MediaQuery.of(context).size.width * 0.9,
                                    height: 50,
                                  )
                                : Container(),
                            SizedBox(
                              width: 1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
