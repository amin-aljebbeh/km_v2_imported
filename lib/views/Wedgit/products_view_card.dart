import 'package:flutter/material.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/utils/utils_importer.dart';

// ignore: must_be_immutable
class ProductsViewCard extends StatefulWidget {
  final String img;
  final String productName;
  final String quantity;
  final int price;
  final int index;
  int active;
  final String productId;
  final String supplierCode;
  final ProductData productData;
  final int subWarehouseId;

  ProductsViewCard({
    this.img,
    this.productName,
    this.quantity,
    this.price,
    this.index,
    this.productId,
    this.supplierCode,
    this.productData,
    this.active,
    @required this.subWarehouseId,
  });

  @override
  State<StatefulWidget> createState() {
    return ProductsViewCardState();
  }
}

class ProductsViewCardState extends State<ProductsViewCard> {
  bool addedToCart = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 0, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                KCacheImage(
                  tag: widget.index + 100,
                  image: widget.img,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    child: Wrap(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.productName,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                                  fontSize: 18),
                            ),
                            SizedBox(height: 6),
                            Text(
                              widget.quantity,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: ColorUtils.greyColor,
                                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                                  fontSize: 17),
                            ),
                            SizedBox(height: 8),
                            Text(
                                StringUtils().oCcy.format(widget.price).toString() +
                                    " ${LoadingScreenServices.companyInformation.currency}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: ColorUtils.primaryColor,
                                    fontFamily: StringUtils.fontFamilyHKGrotesk,
                                    fontSize: 18)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    if (LoadingScreenServices.subWarehouses.any((element) => element.id == widget.subWarehouseId))
                      Column(
                        children: [
                          SwitchProductStatusWidget(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.17,
                            preState: widget.active,
                            subWarehouseId: widget.productData.subWarehouseId,
                            productId: widget.productId,
                            onChange: (active) {
                              setState(() {
                                widget.active = active;
                              });
                            },
                          ),
                        ],
                      ),
                    if (Services.isAdmin())
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.17,
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0) //                 <--- border radius here
                                    ),
                            border: Border.all(color: ColorUtils.primaryColor, width: 2)),
                        child: Center(
                          child: Text(
                            widget.productData.rate != null
                                ? StringUtils().oCcy.format(widget.productData.rate).toString()
                                : '0',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: ColorUtils.primaryColor,
                              fontFamily: StringUtils.fontFamilyHKGrotesk,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
