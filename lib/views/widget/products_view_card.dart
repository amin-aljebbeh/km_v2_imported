import 'package:flutter/material.dart';
import 'package:kammun_app/models/products_categories_model.dart';
import 'package:kammun_app/service.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Widget/widgets_importer.dart';
import 'package:kammun_app/views/loading/loading_services.dart';
import 'package:kammun_app/views/product_detail_view/product_detail_view.dart';
import 'package:kammun_app/views/products_attached_to_warehouse/views/products_attached_to_warehouse_importer.dart';
import 'package:kammun_app/views/products_view/barcode_screen.dart';

// ignore: must_be_immutable
class ProductsViewCard extends StatefulWidget {
  final int index;
  final ProductData productData;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(String) onAddBarcode;
  final Function(String) onChangePrice;

  const ProductsViewCard({
    Key key,
    this.index,
    this.productData,
    this.scaffoldKey,
    this.onAddBarcode,
    this.onChangePrice,
  }) : super(key: key);

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
          MaterialPageRoute(
            builder: (context) => ProductDetailView(
              product: widget.productData,
              onAddBarcode: (result) {
                widget.onAddBarcode(result);
              },
              onChangePrice: (newValue) {
                setState(() {
                  widget.productData.price = newValue;
                  widget.onChangePrice(newValue);
                });
              },
            ),
          ),
        );
      },
      child: Container(
        color: Theme.of(context).primaryColorLight,
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 10),
          child: Row(
            children: <Widget>[
              KCacheImage(
                tag: widget.index + 100,
                image: widget.productData.images.isNotEmpty
                    ? LoadingScreenServices.imagePrefixUrl + widget.productData.images[0].imageFileName
                    : "",
              ),
              const SizedBox(width: 10),
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
                            const SizedBox(height: 6),
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
                            const SizedBox(height: 8),
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
                              if (widget.productData.barcodes.isEmpty) const Icon(BareCodeIcon.exclamation),
                              BarcodeIcon(
                                productData: widget.productData,
                                requestType: BarcodeRequestType.addBarcode,
                                productId: int.parse(widget.productData.id.toString()),
                                scaffoldKey: widget.scaffoldKey,
                                onAddBarcode: (result) => widget.onAddBarcode(result),
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
                                if (result) {
                                  widget.productData.isActive = active.toString();
                                }
                              });
                            },
                          ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Services.isAdmin()
                                ? Text(
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
                                  )
                                : Container(),
                            const SizedBox(
                              height: 5,
                            ),
                            Services.isProductsController()
                                ? Text(
                                    'الكمية: ' +
                                        (widget.productData.availableQuantity != 'null'
                                            ? StringUtils()
                                                .oCcy
                                                .format(
                                                    int.parse(widget.productData.availableQuantity.split('.')[0]))
                                                .toString()
                                            : '0'),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: ColorUtils.primaryColor,
                                      fontFamily: StringUtils.fontFamilyHKGrotesk,
                                      fontSize: 13,
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ],
                    )
                  : Container(
                      height: 58,
                      width: 69,
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                              Radius.circular(10.0) //                 <--- border radius here
                              ),
                          border: Border.all(color: ColorUtils.kmColors, width: 2)),
                      child: IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          if (widget.productData.barcodes.isEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (screenContext) => BarCodeScreen(
                                  productData: widget.productData,
                                  requestType: BarcodeRequestType.attachProduct,
                                  onIgnore: (barcode) async {
                                    int param;
                                    if (barcode == null) {
                                      param = null;
                                    } else {
                                      param = int.parse(barcode);
                                    }
                                    Navigator.push(
                                      widget.scaffoldKey.currentContext,
                                      MaterialPageRoute(
                                        builder: (context) => AddProductsToSubWarehouse(
                                          barcode: param,
                                          productData: widget.productData,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              widget.scaffoldKey.currentContext,
                              MaterialPageRoute(
                                builder: (context) => AddProductsToSubWarehouse(
                                  productData: widget.productData,
                                ),
                              ),
                            );
                          }
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
