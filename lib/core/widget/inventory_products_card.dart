import 'package:kammun_app/features/product_detail_view/product_detail_view.dart';
import 'package:kammun_app/features/products_attached_to_warehouse/services/added_products_services.dart';
import 'package:kammun_app/features/products_view/barcode_screen.dart';
import 'package:kammun_app/features/products_view/services/products_services.dart';
import 'package:kammun_app/features/store/store_view_category_grid.dart';

import '../../core/core_importer.dart';

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
  final Function(String) onChangePrice;
  final Function(String) onChangeUnit;
  final Function(String) onChangeQuantity;
  InventoryProductsViewCard({
    Key key,
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
    this.onChangePrice,
    this.onChangeUnit,
    this.onChangeQuantity,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => InventoryProductsViewCardState();
}

class InventoryProductsViewCardState extends State<InventoryProductsViewCard> {
  String subWarehouseName = '';

  _unAttachProduct() async {
    bool result = await AddedProductsServices.unAttachProductsToSubWarehouseService(
        productsId: widget.productData.id.toString(), subWarehouse: widget.id);
    if (result) widget.onDelete(true);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    String price = widget.price;
    if (Services.isSupplierManager() && widget.price != '0') {
      price = (int.parse(widget.productData.price.split('.')[0]) - widget.productData.increasePercentage).toString();
    }
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0, top: 10),
        child: GestureDetector(
          onTap: () {
            if (widget.productData != null && widget.supplierCode != null) {
              widget.productData.isActive = widget.isActive.toString();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailView(
                    product: widget.productData,
                    onChangePrice: (newValue) =>
                        setState(() => {widget.productData.price = newValue, widget.onChangePrice(newValue)}),
                    onChangeUnit: (newValue) =>
                        setState(() => {widget.productData.unit = newValue, widget.onChangeUnit(newValue)}),
                    onChangeQuantity: (newValue) =>
                        setState(() => {widget.productData.price = newValue, widget.onChangeQuantity(newValue)}),
                  ),
                ),
              );
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(thickness: 0.8, color: Colors.grey[800]),
              Row(
                children: <Widget>[
                  KCacheImage(
                    tag: widget.productData.id + widget.index,
                    image: widget.productData.images.isNotEmpty
                        ? LoadingScreenServices.imagePrefixUrl + widget.productData.images[0].imageFileName
                        : '',
                  ),
                  const SizedBox(width: 10),
                  Expanded(
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
                                    fontFamily: fontFamily,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.productData.quantity +
                                  ' ' +
                                  (widget.productData.unit != 'null' ? widget.productData.unit : ''),
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: greyColor,
                                fontFamily: fontFamily,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              children: [
                                Text(
                                  StringUtils().oCcy.format(int.parse(price.split('.')[0])).toString() + '  ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: primaryColor,
                                    fontFamily: fontFamily,
                                    fontSize: 18,
                                  ),
                                ),
                                if (widget.oldPrice != null)
                                  if (widget.oldPrice.toString() != price)
                                    RichText(
                                        text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: StringUtils()
                                                .oCcy
                                                .format(widget.oldPrice - widget.productData.increasePercentage)
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.grey, decoration: TextDecoration.lineThrough)),
                                      ],
                                    )),
                                if (widget.productData.alertProductsCount != 'null')
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: StringUtils()
                                              .oCcy
                                              .format(int.parse(widget.productData.alertProductsCount)),
                                          style: TextStyle(color: kmColors, fontFamily: fontFamily, fontSize: 14),
                                        ),
                                        TextSpan(
                                          text: 'ينتظرون تفعيل  المنتج',
                                          style: TextStyle(color: kmColors, fontFamily: fontFamily, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
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
                                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                    border: Border.all(color: Colors.red, width: 2)),
                                child: Center(child: Text(widget.deleteTimes.toString(), style: loseStyle)),
                              ),
                            Container(
                              height: 58,
                              width: 69,
                              margin: const EdgeInsets.all(15.0),
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                  border: Border.all(color: primaryColor, width: 2)),
                              child: widget.attached && widget.supplierCode != 'null' && !widget.fromInventory
                                  ? IconButton(
                                      icon: const Icon(Icons.close_sharp, color: Colors.red),
                                      onPressed: () {
                                        subWarehouseName = LoadingScreenServices.subWarehouses
                                            .firstWhere((subWarehouse) => subWarehouse.id.toString() == widget.id,
                                                orElse: () => SubWarehouse(name: 'المستودع'))
                                            .name;
                                        showMyDialog(
                                          context: context,
                                          title: 'حذف منتج من المستودع',
                                          text:
                                              'هل أنت متأكد أنك تريد إزالة ${widget.productData.name} من $subWarehouseName',
                                          dialogButtons: [
                                            DialogButton(
                                                text: yes,
                                                onTap: () async {
                                                  bool result = await _unAttachProduct();
                                                  Navigator.of(context).pop();
                                                  if (result) {
                                                    snackBar(
                                                        success: result,
                                                        message: 'تم إزالة المنتج من المستودع بنجاح',
                                                        context: context);
                                                  } else {
                                                    snackBar(
                                                        success: result,
                                                        message:
                                                            'فشلت عملية إزالة المنتج من المستودع يرجى المحاولة مجدداً',
                                                        context: context);
                                                  }
                                                }),
                                            const CloseWidget(),
                                          ],
                                        );
                                      })
                                  : !widget.fromInventory
                                      ? IconButton(
                                          icon: const Icon(Icons.add, color: Colors.green),
                                          onPressed: () {
                                            if (widget.productData.id == 0) {
                                              Services.productToAddName = widget.productData.name;
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (screenContext) => Scaffold(
                                                      body: SafeArea(
                                                          child: StoreViewCategory(
                                                              scaffoldKey: widget.scaffoldKey,
                                                              supplierCode: widget.supplierCode,
                                                              forProductAdding: true))),
                                                ),
                                              );
                                            } else {
                                              if (widget.barcode == null) {
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
                                                                    barcode: param, productData: widget.productData)));
                                                      },
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                Navigator.push(
                                                  widget.scaffoldKey.currentContext,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddProductsToSubWarehouse(productData: widget.productData)),
                                                );
                                              }
                                            }
                                          })
                                      : IconButton(
                                          icon: const Icon(Icons.check_sharp, color: Colors.green),
                                          onPressed: () async {
                                            bool result = await ProductsServices.updateProductsDetails(
                                                bodyKey: 'under_check_availability',
                                                value: '0',
                                                subWarehouseId: widget.id,
                                                productId: widget.productData.id.toString());
                                            if (result) {
                                              snackBar(
                                                  success: result,
                                                  message: 'تم إزالة المنتج من القائمة بنجاح',
                                                  context: context);
                                            } else {
                                              snackBar(
                                                  success: result,
                                                  message: 'فشلت عملية إزالة المنتج من القائمة يرجى المحاولة مجدداً',
                                                  context: context);
                                            }
                                            if (result) setState(() => widget.onDelete(true));
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
