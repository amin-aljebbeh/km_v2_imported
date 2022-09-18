import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/views/loading/loading_services.dart';
import 'package:kammun_app/views/order_details/invoice_view.dart';

import 'full_screen_image.dart';
import 'services/order_details_services.dart';

class OrderAccounting extends StatefulWidget {
  final OrdersOriginalData orderData;
  final Function onDelete;
  const OrderAccounting({Key key, @required this.orderData, this.onDelete}) : super(key: key);

  @override
  _OrderAccountingState createState() => _OrderAccountingState();
}

class _OrderAccountingState extends State<OrderAccounting> {
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
      imageWidgets.add(InkWell(
        onLongPress: () async {
          List<DialogButton> dialogButtons = [
            DialogButton(
              text: yes,
              onTap: () async {
                Navigator.of(context).pop();
                bool result = await OrderDetailsServices.deleteImageFromOrderService(imageId: images[i].id.toString());
                if (result) {
                  snackBar(success: result, message: 'تم حذف الصورة من الطلب', context: context);
                  setState(() {
                    widget.orderData.images.removeWhere((image) => image.id == widget.orderData.images[i].id);
                    images.clear();
                    images.addAll(widget.orderData.images);
                    widget.onDelete();
                  });
                } else {
                  snackBar(success: result, message: 'فشلت عملية حذف الصورة', context: context);
                }
              },
            ),
            DialogButton(text: no, onTap: () => Navigator.of(context).pop()),
          ];
          showMyDialog(context: context, title: '', text: 'هل تريد حذف الفاتورة ؟', dialogButtons: dialogButtons);
        },
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => FullScreenImage(
                      imageUrl:
                          LoadingScreenServices.imagePrefixUrl + 'orders/' + widget.orderData.images[i].imageFileName,
                      tag: 'generate_a_unique_tag')));
        },
        child: widget.orderData.images != null && widget.orderData.images.isNotEmpty
            ? KCacheImage(
                tag: widget.orderData.images[i].imageFileName,
                image: LoadingScreenServices.imagePrefixUrl + 'orders/' + widget.orderData.images[i].imageFileName)
            : const AssetImage('assets/kmIcon.png'),
      ));
    }
  }

  _calculate() {
    setState(() {
      subWarehouseTotal.clear();
      subWarehouseTotal.add(KTableRow(
        children: [
          const KTableElement(text: 'المورد'),
          const KTableElement(text: 'الدفع للمورد'),
          if (Services.isAccounting()) const KTableElement(text: 'نسبة الزيادة'),
          const KTableElement(text: 'السعر الصافي')
        ],
      ));
      for (int i = 0; i < widget.orderData.orderAccountingRows.length; i++) {
        if (widget.orderData.orderAccountingRows[i].payToSubWarehouse != 0) {
          subWarehouseTotal.add(KTableRow(
            children: [
              KTableElement(text: widget.orderData.orderAccountingRows[i].subWarehouseName),
              KTableElement(
                text: StringUtils().oCcy.format(widget.orderData.orderAccountingRows[i].directDiscount == 1
                    ? Services.kRound(widget.orderData.orderAccountingRows[i].payToSubWarehouse)
                    : widget.orderData.orderAccountingRows[i].payToSubWarehouse),
              ),
              if (Services.isAccounting())
                KTableElement(
                    text: StringUtils().oCcy.format(widget.orderData.orderAccountingRows[i].increaseValuesSum)),
              KTableElement(
                  text: StringUtils().oCcy.format(widget.orderData.orderAccountingRows[i].netPrice +
                      widget.orderData.orderAccountingRows[i].increaseValuesSum)),
            ],
          ));
        }
      }
      if (!Services.isSupplierManager()) {
        int delivery = int.parse(widget.orderData.supportedCityCost.split('.')[0]) +
            int.parse(widget.orderData.deliveryCost.split('.')[0]) +
            int.parse(widget.orderData.collectingCost.split('.')[0]);
        int subTotal = int.parse(widget.orderData.total.split('.')[0]) - delivery;
        subWarehouseTotal.add(KTableRow(
            children: [KTableElement(text: subtotalString), KTableElement(text: StringUtils().oCcy.format(subTotal))]));
        subWarehouseTotal.add(KTableRow(children: [
          const KTableElement(text: 'أجور التوصيل'),
          KTableElement(text: StringUtils().oCcy.format(delivery))
        ]));
        subWarehouseTotal.add(KTableRow(children: [
          const KTableElement(text: 'قيمة كود الحسم'),
          KTableElement(
              text: StringUtils().oCcy.format(int.parse(widget.orderData.couponValue.split('.')[0])),
              style: lightLoseStyle)
        ]));
        subWarehouseTotal.add(KTableRow(children: [
          const KTableElement(text: 'قيمة المحفظة'),
          KTableElement(
              text: StringUtils().oCcy.format(int.parse(widget.orderData.walletValue.split('.')[0])),
              style: lightLoseStyle)
        ]));
        subWarehouseTotal.add(KTableRow(children: [
          KTableElement(text: totalString),
          KTableElement(
              text: StringUtils().oCcy.format(int.parse(widget.orderData.total.split('.')[0]) -
                  int.parse(widget.orderData.walletValue.split('.')[0])))
        ]));
      } else {
        subWarehouseTotal.add(KTableRow(children: [
          KTableElement(text: totalString),
          KTableElement(
              text: StringUtils().oCcy.format(Services.kRound(
                  widget.orderData.orderAccountingRows.fold(0, (sum, row) => sum + row.payToSubWarehouse))))
        ]));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _calculate();
    if (widget.orderData.images != null) getImages();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                Column(children: subWarehouseTotal),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: GridView(
                        scrollDirection: Axis.vertical,
                        primary: false,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(left: 0, right: 0, top: 4, bottom: 4),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 2),
                        children: imageWidgets)),
                SizedBox(height: MediaQuery.of(context).size.height * 0.4),
              ],
            ),
            Positioned(
              bottom: 25,
              right: MediaQuery.of(context).size.width * 0.05,
              child: Column(
                children: [
                  AddImageWidget(
                    onSubmit: (image) async {
                      bool result = await OrderDetailsServices.addImageToOrderService(
                          image: image, orderId: widget.orderData.id.toString());
                      if (result) {
                        snackBar(success: result, message: 'نجحت عملية إضافة الصورة', context: context);
                      } else {}
                      setState(() {
                        snackBar(success: result, message: 'فشلت عملية إضافة الصورة', context: context);
                      });
                    },
                  ),
                  if (Services.isOperationManager())
                    KammunButton(
                      color: kmColors,
                      onTap: () {
                        if (widget.orderData.shopper == null) {
                          Toast.show('هذا الطلب غير مسند لمتسوق', context,
                              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddTransactionView(
                                      orderId: widget.orderData.id, shopperName: widget.orderData.shopper.name)));
                        }
                      },
                      text: addTransaction,
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 50,
                    ),
                  if (!Services.isSupplierManager())
                    KammunButton(
                      color: kmColors,
                      onTap: () => Navigator.push(
                          context, MaterialPageRoute(builder: (context) => InvoiceView(orderId: widget.orderData.id))),
                      text: 'تفاصيل فاتورة الزبون',
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 50,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
