import 'package:flutter/material.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Widget/widgets_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/product_detail_view/product_detail_view.dart';
import 'package:kammun_app/views/products_attached_to_warehouse/views/products_attached_to_warehouse_importer.dart';
import 'package:kammun_app/views/products_view/barcode_screen.dart';

// ignore: must_be_immutable
class ProductsViewCard extends StatefulWidget {
  final int index;
  final ProductData productData;
  final GlobalKey<ScaffoldState> scaffoldKey;

  ProductsViewCard({
    this.index,
    this.productData,
    this.scaffoldKey,
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
        if (widget.productData.subWarehouseId != -1)
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => new ProductDetailView(
                product: widget.productData,
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
                image: widget.productData.images.length > 0
                    ? LoadingScreenServices.imagePrefixUrl + widget.productData.images[0].imageFileName
                    : "",
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.productData.name,
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
                              widget.productData.unit != "null"
                                  ? widget.productData.quantity + " " + widget.productData.unit
                                  : widget.productData.quantity,
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
                          Row(
                            children: [
                              if (widget.productData.barcodes.isEmpty) Icon(BareCodeIcon.exclamation),
                              BarcodeIcon(
                                requestType: BarcodeRequestType.addBarcode,
                                productId: int.parse(widget.productData.id.toString()),
                                scaffoldKey: widget.scaffoldKey,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              widget.productData.subWarehouseId != -1
                  ? Column(
                      children: [
                        if (LoadingScreenServices.subWarehouses
                            .any((element) => element.id == widget.productData.subWarehouseId))
                          SwitchProductStatusWidget(
                            isForSubWarehouse: true,
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.17,
                            preState: int.parse(widget.productData.isActive),
                            subWarehouseId: widget.productData.subWarehouseId,
                            productId: widget.productData.id.toString(),
                            onChange: (int active, bool result) {
                              setState(() {
                                if (result) widget.productData.isActive = active.toString();
                              });
                            },
                          ),
                        if (Services.isAdmin())
                          Column(
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'التقييم: ' +
                                    (widget.productData.rate != -1
                                        ? StringUtils().oCcy.format(widget.productData.rate).toString()
                                        : '0'),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.primaryColor,
                                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'الكمية: ' +
                                    (widget.productData.availableQuantity != 'null'
                                        ? StringUtils()
                                            .oCcy
                                            .format(int.parse(widget.productData.availableQuantity.split('.')[0]))
                                            .toString()
                                        : '0'),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.primaryColor,
                                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                      ],
                    )
                  : Container(
                      height: 58,
                      width: 69,
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0) //                 <--- border radius here
                                  ),
                          border: Border.all(color: ColorUtils.kmColors, width: 2)),
                      child: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          if (widget.productData.barcodes.isEmpty)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (screenContext) => BarCodeScreen(
                                  requestType: BarcodeRequestType.attachProduct,
                                  onIgnore: (barcode) async {
                                    int param;
                                    if (barcode == null)
                                      param = null;
                                    else
                                      param = int.parse(barcode);
                                    Navigator.push(
                                      widget.scaffoldKey.currentContext,
                                      new MaterialPageRoute(
                                        builder: (context) => new AddProductsToSubWarehouse(
                                          barcode: param,
                                          productData: widget.productData,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          else
                            Navigator.push(
                              widget.scaffoldKey.currentContext,
                              new MaterialPageRoute(
                                builder: (context) => new AddProductsToSubWarehouse(
                                  productData: widget.productData,
                                ),
                              ),
                            );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
