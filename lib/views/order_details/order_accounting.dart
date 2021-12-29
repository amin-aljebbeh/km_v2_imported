import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kammun_app/models/start_model.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/add_image_widget.dart';
import 'package:kammun_app/views/Wedgit/dialog_button.dart';
import 'package:kammun_app/views/Wedgit/k_table_row.dart';
import 'package:kammun_app/views/Wedgit/k_table_element.dart';
import 'package:kammun_app/views/Wedgit/my_dialog.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';

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
                text: UtilsImporter().stringUtils.yes,
                onTap: () async {
                  Navigator.of(context).pop();
                  bool result = await OrderDetailsServices.deleteImageFromOrder(
                      imageId: widget.orderData.images[i].id.toString());
                  Services.resultFlushBar(context: context, result: result);
                  if (result)
                    setState(() {
                      widget.orderData.images.removeWhere(
                          (image) => image.id == widget.orderData.images[i].id);
                      imageWidgets.clear();
                    });
                },
              ),
              DialogButton(
                text: UtilsImporter().stringUtils.no,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ];
            showMyDialog(
                title: '',
                context: context,
                text: 'هل تريد حذف الفاتورة ؟',
                dialogButtons: dialogButtons);
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
          child: new Container(
            width: 100.0,
            height: 100.0,
            decoration: new BoxDecoration(
                borderRadius: new BorderRadius.all(Radius.circular(20.0))),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Hero(
                tag: i + 100,
                child: Image(
                  // fadeInCurve: Curves.fastOutSlowIn,
                  // placeholder: AssetImage("assets/kmIcon.png"),
                  fit: BoxFit.contain,
                  image: widget.orderData.images != null &&
                          widget.orderData.images.length > 0
                      ? AdvImageCache(
                          LoadingScreenServices.imagePrefixUrl +
                              'orders/' +
                              widget.orderData.images[i].imageFileName,
                          useMemCache: true,
                          diskCacheExpire: Duration(days: 400),
                        )
                      : AssetImage("assets/kmIcon.png"),
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                ),
              ),
            ),
          ),
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
              KTableElement(text: 'القبض من الزبون'),
              KTableElement(text: 'الدفع للمورد'),
            ],
          ),
        );
        for (int i = 0; i < widget.orderData.orderAccountingRows.length; i++) {
          subWarehouseTotal.add(
            KTableRow(
              children: [
                KTableElement(
                    text: widget
                        .orderData.orderAccountingRows[i].subWarehouseName),
                KTableElement(
                    text: widget.orderData.orderAccountingRows[i].customerPay
                        .toString()),
                KTableElement(
                    text: widget
                        .orderData.orderAccountingRows[i].payToSubWarehouse
                        .toString()),
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
                bool result = await OrderDetailsServices.addImageToOrder(
                    image: image, orderId: widget.orderId.toString());
                Services.resultFlushBar(context: context, result: result);
              },
            ),
          ],
        ),
      ),
    );
  }
}
