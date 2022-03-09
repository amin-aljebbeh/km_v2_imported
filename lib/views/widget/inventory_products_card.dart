import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/views/Widget/widgets_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/product_detail_view/product_detail_view.dart';
import 'package:kammun_app/views/products_attached_to_warehouse/services/added_products_services.dart';
import 'package:kammun_app/views/products_attached_to_warehouse/views/add_products_to_sub_warehouse.dart';
import 'package:kammun_app/views/products_view/barcode_screen.dart';
import 'package:kammun_app/views/products_view/services/products_services.dart';
import 'package:kammun_app/views/store/store_view_category_grid.dart';

import '../../utils/utils_importer.dart';

// ignore: must_be_immutable
class InventoryProductsViewCard extends StatefulWidget {
  final Function(bool) onChangeStatus;
  final int oldPrice;
  final ProductData productData;
  final Function(bool) onDelete;
  final bool fromInventory;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String barcode;
  final String price;
  final String id;
  final String supplierCode;
  int isActive;
  final bool attached;
  final int index;
  final int deleteTimes;

  InventoryProductsViewCard({
    this.onChangeStatus,
    this.oldPrice,
    this.productData,
    this.onDelete,
    this.fromInventory = false,
    this.scaffoldKey,
    this.barcode,
    this.price,
    this.id,
    this.supplierCode,
    this.isActive,
    this.attached,
    this.index,
    this.deleteTimes = -1,
  });

  @override
  State<StatefulWidget> createState() {
    return InventoryProductsViewCardState();
  }
}

class InventoryProductsViewCardState extends State<InventoryProductsViewCard> {
  String subWarehouseName = '';

  _unAttachProduct() async {
    bool result = await AddedProductsServices.unAttachProductsToSubWarehouse(
      productsId: widget.productData.id.toString(),
      subWarehouse: widget.id,
    );
    Services.resultFlushBar(context: context, result: result);
    if (result) {
      widget.onDelete(true);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Tools.logToConsole(widget.productData.id);
    String price = widget.price;
    if (Services.isSupplierManager() && widget.price != '0') {
      price =
          (int.parse(widget.productData.price.split('.')[0]) - widget.productData.increasePercentage).toString();
    }
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 0, top: 10),
        child: GestureDetector(
          onTap: () {
            if (widget.productData != null && widget.supplierCode != null) {
              widget.productData.isActive = widget.isActive.toString();
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new ProductDetailView(
                    product: widget.productData,
                  ),
                ),
              );
            }
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
                children: <Widget>[
                  KCacheImage(
                    tag: widget.productData.id + widget.index,
                    image: widget.productData.images.length > 0
                        ? LoadingScreenServices.imagePrefixUrl + widget.productData.images[0].imageFileName
                        : "",
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      child: Wrap(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Wrap(
                                children: <Widget>[
                                  Text(
                                    widget.productData.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontFamily: StringUtils.fontFamilyHKGrotesk,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Text(
                                widget.productData.quantity +
                                    ' ' +
                                    (widget.productData.unit != 'null' ? widget.productData.unit : ''),
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: ColorUtils.greyColor,
                                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                                  fontSize: 17,
                                ),
                              ),
                              SizedBox(height: 8),
                              Wrap(
                                children: [
                                  Text(
                                    StringUtils().oCcy.format(int.parse(price.split('.')[0])).toString() + "  ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: ColorUtils.primaryColor,
                                      fontFamily: StringUtils.fontFamilyHKGrotesk,
                                      fontSize: 18,
                                    ),
                                  ),
                                  widget.oldPrice != null
                                      ? RichText(
                                          text: new TextSpan(
                                            children: <TextSpan>[
                                              new TextSpan(
                                                text: StringUtils()
                                                    .oCcy
                                                    .format(
                                                        widget.oldPrice - widget.productData.increasePercentage)
                                                    .toString(),
                                                style: new TextStyle(
                                                  color: Colors.grey,
                                                  decoration: TextDecoration.lineThrough,
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        widget.supplierCode != null &&
                                LoadingScreenServices.subSupplierCodeHint.hasMatch(widget.supplierCode) &&
                                widget.isActive != null &&
                                widget.id != null
                            ? Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: SwitchProductStatusWidget(
                                  isForSubWarehouse: true,
                                  preState: widget.isActive,
                                  subWarehouseId: int.parse(widget.id),
                                  productId: widget.productData.id.toString(),
                                  onChange: (int active, bool result) {
                                    setState(() {
                                      if (result) widget.isActive = active;
                                    });
                                    widget.onChangeStatus(result);
                                    setState(() {});
                                  },
                                  height: 58,
                                  width: 69,
                                ),
                              )
                            : Container(),
                        Row(
                          children: [
                            if (widget.deleteTimes != -1)
                              Container(
                                height: 58,
                                width: 69,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0) //                 <--- border radius here
                                        ),
                                    border: Border.all(color: Colors.red, width: 2)),
                                child: Center(
                                  child: Text(
                                    widget.deleteTimes.toString(),
                                    style: loseStyle,
                                  ),
                                ),
                              ),
                            Container(
                              height: 58,
                              width: 69,
                              margin: const EdgeInsets.all(15.0),
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10.0) //                 <--- border radius here
                                      ),
                                  border: Border.all(color: ColorUtils.primaryColor, width: 2)),
                              child: widget.attached && widget.supplierCode != null && !widget.fromInventory
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.close_sharp,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        List<DialogButton> dialogButtons = [
                                          DialogButton(
                                            text: StringUtils.yes,
                                            onTap: () {
                                              _unAttachProduct();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          DialogButton(
                                            text: StringUtils.close,
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ];
                                        subWarehouseName = LoadingScreenServices.subWarehouses
                                            .firstWhere((subWarehouse) => subWarehouse.id.toString() == widget.id,
                                                orElse: () => SubWarehouse(name: 'المستودع'))
                                            .name;
                                        showMyDialog(
                                          title: "حذف منتج من المستودع",
                                          text:
                                              "هل أنت متأكد أنك تريد إزالة ${widget.productData.name} من $subWarehouseName",
                                          dialogButtons: dialogButtons,
                                          context: context,
                                        );
                                      },
                                    )
                                  : !widget.fromInventory
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.add,
                                            color: Colors.green,
                                          ),
                                          onPressed: () {
                                            if (widget.productData.id == 0) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (screenContext) => Scaffold(
                                                    body: SafeArea(
                                                      child: StoreViewCategory(
                                                        scaffoldKey: widget.scaffoldKey,
                                                        supplierCode: widget.supplierCode,
                                                        forProductAdding: true,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              if (widget.barcode == null)
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
                                            }
                                          },
                                        )
                                      : IconButton(
                                          icon: Icon(
                                            Icons.check_sharp,
                                            color: Colors.green,
                                          ),
                                          onPressed: () async {
                                            bool result = await ProductsServices.updateProductsDetails(
                                                bodyKey: "under_check_availability",
                                                value: "0",
                                                subWarehouseId: widget.id,
                                                productId: widget.productData.id.toString());
                                            Services.resultFlushBar(context: context, result: result);

                                            if (result) {
                                              widget.onDelete(true);
                                              setState(() {});
                                            }
                                          },
                                        ),
                            ),
                          ],
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
