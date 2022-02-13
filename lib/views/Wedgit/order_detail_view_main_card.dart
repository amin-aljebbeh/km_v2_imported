import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/order_details/full_screen_image.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/order_details/services/order_details_services.dart';

import 'k_cache_image.dart';

// ignore: must_be_immutable
class OrderDetailViewMainCard extends StatefulWidget {
  final int index;
  final OrderProducts productData;

  Function(int) onCheckbox;

  OrderDetailViewMainCard({
    this.index,
    this.productData,
    this.onCheckbox,
  });

  @override
  State<StatefulWidget> createState() {
    return OrderDetailViewMainCardState();
  }
}

class OrderDetailViewMainCardState extends State<OrderDetailViewMainCard> {
  List<DropdownMenuItem> subWarehouseList = [];
  @override
  void initState() {
    subWarehouseList = LoadingScreenServices.subWarehouses
        .map(
          (subWarehouse) => DropdownMenuItem(
            child: AutoSizeText(
              subWarehouse.name,
              maxLines: 2,
              overflow: TextOverflow.fade,
              maxFontSize: 12,
              style: mainStyle,
            ),
            value: subWarehouse.id,
          ),
        )
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int purchasePrice = int.parse(widget.productData.pivot.purchasePrice.split('.')[0]);
    double discountPercentage = SubWarehouse.getDiscountPercentage(widget.productData.subWarehouseId);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            ProductCheckWidget(
              productData: widget.productData,
              preferLeftSide: !LoadingScreenServices.preferLeftSide,
              productCount: widget.productData.pivot.quantity,
              productName: widget.productData.name,
              index: widget.index,
              onCheckbox: (index) => widget.onCheckbox(index),
            ), //right side
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return FullScreenImage(
                        imageUrl: widget.productData.images.length != 0
                            ? LoadingScreenServices.imagePrefixUrl + widget.productData.images[0].imageFileName
                            : "",
                        tag: "generate_a_unique_tag",
                      );
                    },
                  ),
                );
              },
              child: KCacheImage(
                tag: widget.index + int.parse(widget.productData.pivot.productId),
                image: widget.productData.images.length != 0
                    ? LoadingScreenServices.imagePrefixUrl + widget.productData.images[0].imageFileName
                    : "",
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.productData.name,
                    style: mainStyle.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.productData.quantity +
                        " " +
                        (widget.productData.unit == null ? '' : widget.productData.unit),
                    style: darkBold,
                  ),
                  Text(
                    StringUtils().oCcy.format(purchasePrice).toString() +
                        " ${LoadingScreenServices.companyInformation.currency}",
                    style: paragraphStyle,
                  ),
                  if (Services.isSupplierManager())
                    Text(
                      StringUtils().oCcy.format(purchasePrice - (purchasePrice * discountPercentage)).toString() +
                          " ${LoadingScreenServices.companyInformation.currency}",
                      style: paragraphStyle,
                    ),
                  if ((!Services.isSupplierManager()) && subWarehouseList.length > 0)
                    DropdownButton(
                      items: subWarehouseList,
                      onChanged: (a) {
                        OrderDetailsServices.updateOrder(
                          orderId: widget.productData.pivot.orderId,
                          context: context,
                          updateKey: "sub_warehouse_id",
                          updateValue: a.toString(),
                          productId: widget.productData.pivot.productId,
                        );
                        setState(() {
                          widget.productData.subWarehouseId = a;
                        });
                      },
                      hint: subWarehouseList
                          .firstWhere((element) => element.value == widget.productData.subWarehouseId, orElse: () {
                        subWarehouseList.clear();
                        return DropdownMenuItem<int>(
                          child: Text("No element"),
                          value: 0,
                        );
                      }).child,
                    ),
                ],
              ),
            ),
            Row(
              children: [
                ProductCheckWidget(
                  productData: widget.productData,
                  preferLeftSide: LoadingScreenServices.preferLeftSide,
                  productCount: widget.productData.pivot.quantity,
                  productName: widget.productData.name,
                  index: widget.index,
                  onCheckbox: (index) => widget.onCheckbox(index),
                ),
              ],
            ),
          ],
        ),
        Divider()
      ],
    );
  }
}
