import 'package:flutter/material.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/product_detail_view/product_detail_view.dart';

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
  @override
  Widget build(BuildContext context) {
    String price = widget.productData.price;
    if (Services.isSupplierManager()) {
      price =
          (int.parse(widget.productData.price.split('.')[0]) - widget.productData.increasePercentage).toString();
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new ProductDetailView(
              product: widget.productData,
              isFromFavoriteScreen: false,
            ),
          ),
        );
      },
      child: Container(
        color: Theme.of(context).primaryColorLight,
        child: Padding(
          padding: EdgeInsets.only(left: 0, right: 0, top: 10),
          child: Row(
            children: <Widget>[
              KCacheImage(
                tag: widget.index + 100,
                image: widget.img,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.productName,
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontFamily: StringUtils.fontFamilyHKGrotesk, fontSize: 18),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                StringUtils().oCcy.format(int.parse(price.split('.')[0])).toString() +
                                    " ${LoadingScreenServices.companyInformation.currency}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: ColorUtils.primaryColor,
                                    fontFamily: StringUtils.fontFamilyHKGrotesk,
                                    fontSize: 18)),
                          ],
                        ),
                        if (Services.isProductsController())
                          BarcodeIcon(
                            requestType: BarcodeRequestType.addBarcode,
                            productId: int.parse(widget.productId),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  if (LoadingScreenServices.subWarehouses.any((element) => element.id == widget.subWarehouseId))
                    SwitchProductStatusWidget(
                      isForSubWarehouse: true,
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.17,
                      preState: widget.active,
                      subWarehouseId: widget.productData.subWarehouseId,
                      productId: widget.productId,
                      onChange: (int active, bool result) {
                        setState(() {
                          if (result) widget.active = active;
                        });
                      },
                    ),
                  if (Services.isAdmin())
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.17,
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
        ),
      ),
    );
  }
}
