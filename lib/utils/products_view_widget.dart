import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/utils/tools.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/Wedgit/dialog_button.dart';
import 'package:kammun_app/views/Wedgit/my_dialog.dart';
import 'package:kammun_app/views/Wedgit/switch_product_status_widget.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/product_detail_view/product_detail_view.dart';
import 'package:kammun_app/views/products_attached_to_warehouse/services/added_products_services.dart';
import 'package:kammun_app/views/products_attached_to_warehouse/views/add_products_to_sub_warehouse.dart';
import 'package:kammun_app/views/products_view/services/products_services.dart';

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
  Function(bool) onChangeStatus;
  final int oldPrice;
  final bool attached;
  final ProductData productData;
  final Function(bool) onDelete;
  final bool fromInventory;

  ProductsViewCard(
      {this.img,
      this.productName,
      this.quantity,
      this.price,
      this.index,
      this.productId,
      this.supplierCode,
      this.onChangeStatus,
      this.oldPrice,
      this.active,
      this.productData,
      this.onDelete,
      this.fromInventory = false,
      this.attached = true});

  @override
  State<StatefulWidget> createState() {
    return ProductsViewCardState();
  }
}

class ProductsViewCardState extends State<ProductsViewCard> {
  _unAttachProduct() async {
    bool result = await AddedProductsServices.unAttachProductsToSubWarehouse(
        productsId: widget.productId,
        subWarehouse: widget.productData.subWarehouseId.toString());
    Services.resultFlushBar(context: context, result: result);
    if (result) {
      widget.onDelete(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 0, top: 10),
        child: GestureDetector(
          onTap: () {
            if (widget.productData != null &&
                widget.productData.supplierCode != null)
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new ProductDetailView(
                            product: widget.productData,
                            isFromFavoriteScreen: false,
                          )));
            Tools.logToConsole("Products Data is null");
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(
                thickness: 0.8,
                color: Colors.grey[800],
              ),
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: new BoxDecoration(
                        borderRadius:
                            new BorderRadius.all(Radius.circular(20.0))),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Hero(
                            tag: widget.productId,
                            child: Image(
                              // fadeInCurve: Curves.fastOutSlowIn,
                              // placeholder: AssetImage("assets/kmIcon.png"),
                              fit: BoxFit.contain,
                              image: widget.img.length > 0
                                  ? AdvImageCache(
                                      widget.img,
                                      useMemCache: true,
                                      diskCacheExpire: Duration(days: 400),
                                    )
                                  : AssetImage("assets/kmIcon.png"),
                              width: MediaQuery.of(context).size.width,
                              height: 120,
                            ))),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      child: Wrap(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Wrap(
                                children: <Widget>[
                                  Text(
                                    widget.productName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontFamily: UtilsImporter()
                                            .stringUtils
                                            .HKGrotesk,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Text(
                                widget.quantity,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: UtilsImporter().colorUtils.greycolor,
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk,
                                    fontSize: 17),
                              ),
                              SizedBox(height: 8),
                              Wrap(
                                children: [
                                  widget.price != null
                                      ? Text(
                                          UtilsImporter()
                                                  .stringUtils
                                                  .oCcy
                                                  .format(widget.price)
                                                  .toString() +
                                              "  ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: UtilsImporter()
                                                  .colorUtils
                                                  .primarycolor,
                                              fontFamily: UtilsImporter()
                                                  .stringUtils
                                                  .HKGrotesk,
                                              fontSize: 18))
                                      : Container(),
                                  widget.oldPrice != null
                                      ? RichText(
                                          text: new TextSpan(
                                            children: <TextSpan>[
                                              new TextSpan(
                                                text: UtilsImporter()
                                                    .stringUtils
                                                    .oCcy
                                                    .format(widget.oldPrice)
                                                    .toString(),
                                                style: new TextStyle(
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        widget.supplierCode != null &&
                                LoadingScreenServices.subSupplierCodeHint
                                    .hasMatch(widget.supplierCode) &&
                                widget.active != null
                            ? SwitchProductStatusWidget(
                                preState: widget.active,
                                subWarehouseId:
                                    widget.productData.subWarehouseId,
                                productId: widget.productData.id.toString(),
                                onChange: (active) {
                                  setState(() {
                                    widget.active = active;
                                  });
                                  widget.onChangeStatus(true);
                                },
                                height: 58,
                                width: 69,
                              )
                            : Container(),
                        Container(
                          height: 58,
                          width: 69,
                          margin: const EdgeInsets.all(15.0),
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(
                                      10.0) //                 <--- border radius here
                                  ),
                              border: Border.all(
                                  color:
                                      UtilsImporter().colorUtils.primarycolor,
                                  width: 2)),
                          child: widget.attached &&
                                  widget.supplierCode != null &&
                                  !widget.fromInventory
                              ? IconButton(
                                  icon: Icon(
                                    Icons.close_sharp,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    List<DialogButton> dialogButtons = [
                                      DialogButton(
                                        text: UtilsImporter().stringUtils.yes,
                                        onTap: () {
                                          _unAttachProduct();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      DialogButton(
                                        text: UtilsImporter().stringUtils.close,
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ];
                                    showMyDialog(
                                      title: "حذف منتج من المستودع",
                                      text:
                                          "هل أنت متأكد أنك تريد إزالة $widget.productName من المستودع",
                                      dialogButtons: dialogButtons,
                                      context: context,
                                    );
                                  })
                              : !widget.fromInventory
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    new AddProductsToSubWarehouse(
                                                      productData:
                                                          widget.productData,
                                                    )));
                                      })
                                  : IconButton(
                                      icon: Icon(
                                        Icons.check_sharp,
                                        color: Colors.green,
                                      ),
                                      onPressed: () async {
                                        bool result = await ProductsServices
                                            .updateProductsDetails(
                                                bodyKey:
                                                    "under_check_availability",
                                                value: "0",
                                                isForSubWarehouse: true,
                                                subWarehouseId: widget
                                                    .productData.subWarehouseId
                                                    .toString(),
                                                productId: widget.productData.id
                                                    .toString());
                                        Services.resultFlushBar(
                                            context: context, result: result);

                                        if (result) {
                                          widget.onChangeStatus(true);
                                        }
                                      }),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
