import 'package:flutter/material.dart';
import 'package:kammun_app/Services.dart';
import 'package:kammun_app/models/models_importer.dart';
import 'package:kammun_app/models/productsCategoriesModel.dart';
import 'package:kammun_app/views/Wedgit/widgets_importer.dart';
import 'package:kammun_app/views/loading/LoadingServices.dart';
import 'package:kammun_app/views/product_detail_view/product_detail_view.dart';
import 'package:kammun_app/views/products_attached_to_warehouse/services/added_products_services.dart';
import 'package:kammun_app/views/products_attached_to_warehouse/views/add_products_to_sub_warehouse.dart';
import 'package:kammun_app/views/products_view/services/products_services.dart';
import '../../utils/utils_importer.dart';

// ignore: must_be_immutable
class InventoryProductsViewCard extends StatefulWidget {
  int active;
  Function(bool) onChangeStatus;
  final int oldPrice;
  final bool attached;
  final ProductData productData;
  final Function(bool) onDelete;
  final bool fromInventory;

  InventoryProductsViewCard({
    this.onChangeStatus,
    this.oldPrice,
    this.active,
    this.productData,
    this.onDelete,
    this.fromInventory = false,
    this.attached = true,
  });

  @override
  State<StatefulWidget> createState() {
    return InventoryProductsViewCardState();
  }
}

class InventoryProductsViewCardState extends State<InventoryProductsViewCard> {
  String subWarehouseName = '';
  String id;
  String supplierCode;

  _unAttachProduct() async {
    if (widget.productData.subWarehouseId != null)
      id = widget.productData.subWarehouseId.toString();
    else {
      List<int> warehousesIds = LoadingScreenServices.warehouses.map((warehouse) => warehouse.id).toList();
      id = widget.productData.warehouses
          .firstWhere((warehouse) => warehousesIds.contains(warehouse.id),
              orElse: () => LoadingScreenServices.warehouses[0])
          .pivot
          .subWarehouseId;
    }
    bool result = await AddedProductsServices.unAttachProductsToSubWarehouse(
      productsId: widget.productData.id.toString(),
      subWarehouse: id,
    );
    Services.resultFlushBar(context: context, result: result);
    if (result) {
      widget.onDelete(true);
    }
  }

  @override
  void initState() {
    if (widget.productData.supplierCode != null)
      supplierCode = widget.productData.supplierCode;
    else if (widget.productData.warehouses.isNotEmpty)
      supplierCode = widget.productData.warehouses[0].pivot.supplierCode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String price = widget.productData.price;
    if (price == 'null') {
      if (widget.productData.warehouses.isNotEmpty)
        price = widget.productData.warehouses[0].pivot.price;
      else
        price = '0';
    }
    if (Services.isSupplierManager() && price != '0') {
      price =
          (int.parse(widget.productData.price.split('.')[0]) - widget.productData.increasePercentage).toString();
    }
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 0, top: 10),
        child: GestureDetector(
          onTap: () {
            if (widget.productData != null && supplierCode != null)
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
                    tag: widget.productData.id,
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
                                widget.productData.quantity + ' ' + widget.productData.unit != 'null'
                                    ? widget.productData.unit
                                    : '',
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
                                  price != null
                                      ? Text(
                                          StringUtils().oCcy.format(int.parse(price.split('.')[0])).toString() +
                                              "  ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: ColorUtils.primaryColor,
                                            fontFamily: StringUtils.fontFamilyHKGrotesk,
                                            fontSize: 18,
                                          ),
                                        )
                                      : Container(),
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
                      children: [
                        supplierCode != null &&
                                LoadingScreenServices.subSupplierCodeHint.hasMatch(supplierCode) &&
                                widget.active != null
                            ? SwitchProductStatusWidget(
                                isForSubWarehouse: widget.fromInventory,
                                preState: widget.active,
                                subWarehouseId: widget.productData.subWarehouseId,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0) //                 <--- border radius here
                                      ),
                              border: Border.all(color: ColorUtils.primaryColor, width: 2)),
                          child: widget.attached && supplierCode != null && !widget.fromInventory
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
                                        .firstWhere((subWarehouse) => subWarehouse.id.toString() == id,
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
                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                            builder: (context) => new AddProductsToSubWarehouse(
                                              productData: widget.productData,
                                            ),
                                          ),
                                        );
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
                                            isForSubWarehouse: true,
                                            subWarehouseId: widget.productData.subWarehouseId.toString(),
                                            productId: widget.productData.id.toString());
                                        Services.resultFlushBar(context: context, result: result);

                                        if (result) {
                                          widget.onChangeStatus(true);
                                        }
                                      },
                                    ),
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
