import 'package:kammun_app/features/barcode/presentation/pages/barcode_scanner_page.dart';
import 'package:kammun_app/features/barcode/presentation/redux/barcode_action.dart';
import 'package:kammun_app/features/general_information/data/models/sub_warehouse_model.dart';
import 'package:kammun_app/features/product_details/presentation/pages/product_detail_view.dart';
import 'package:kammun_app/features/products/domain/entities/product_entity.dart';
import 'package:kammun_app/features/products_view/services/products_services.dart';
import 'package:kammun_app/features/store/widgets/store_view_category_grid.dart';

import '../../../../core/core_importer.dart';
import '../../../products_view/pages/add_products_to_sub_warehouse.dart';

class InventoryProductWidget extends StatelessWidget {
  final Function(bool) onChangeStatus;
  final int oldPrice;
  final ProductEntity productData;
  final Function(bool) onDelete;
  final bool fromInventory;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String barcode;
  final String price;
  final String id;
  final String supplierCode;
  final int isActive;
  final bool attached;
  final int index;
  final int deleteTimes;
  final Function(String) onChangePrice;
  final Function(String) onChangeUnit;
  final Function(String) onChangeQuantity;
  final Function(String) onChangeSubWarehouse;

  const InventoryProductWidget({
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
    this.onChangeSubWarehouse,
  }) : super(key: key);

  _unAttachProduct() async {
    bool result = await ProductsServices.unAttachProductsToSubWarehouseService(
        productsId: productData.id.toString(), subWarehouse: id);
    if (result) onDelete(true);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    int active = isActive;
    String productPrice = price;
    ProductEntity product = productData;
    if (Services.hasRole(context, supplierRole) && productPrice != '0') {
      productPrice = (int.parse(product.price.split('.')[0]) - product.increasePercentage).toString();
    }
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: InkWell(
            onTap: () {
              if (product != null && supplierCode != null) {
                product.isActive = active.toString();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailView(
                      product: product,
                      onChangeSubWarehouse: (id) => {product.subWarehouseId = int.parse(id), onChangeSubWarehouse(id)},
                      onChangePrice: (newValue) => {product.price = newValue, onChangePrice(newValue)},
                      onChangeUnit: (newValue) => {product.unit = newValue, onChangeUnit(newValue)},
                      onChangeQuantity: (newValue) => {product.price = newValue, onChangeQuantity(newValue)},
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
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: KCacheImage(
                        tag: product.id + index,
                        image: product.images.isNotEmpty
                            ? state.generalInformationState.companyInformation.imagePrefixUrl +
                                product.images[0].imageFileName
                            : '',
                      ),
                    ),
                    Expanded(
                      child: Wrap(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(product.name, style: mainStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 18)),
                              Padding(
                                padding: const EdgeInsets.only(top: 6, bottom: 8),
                                child: Text(
                                  product.quantity + ' ' + (product.unit != 'null' ? product.unit : ''),
                                  style: mainStyle.copyWith(
                                      fontWeight: FontWeight.w400, color: primaryColor, fontSize: 17),
                                ),
                              ),
                              Wrap(
                                children: [
                                  Text(StringUtils().oCcy.format(int.parse(productPrice.split('.')[0])) + '  ',
                                      style: mainStyle.copyWith(
                                          fontWeight: FontWeight.w700, color: primaryColor, fontSize: 18)),
                                  if (oldPrice != null)
                                    if (oldPrice.toString() != productPrice)
                                      RichText(
                                          text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: StringUtils().oCcy.format(oldPrice - product.increasePercentage),
                                              style: mainStyle.copyWith(
                                                  color: Colors.grey, decoration: TextDecoration.lineThrough)),
                                        ],
                                      )),
                                  Text(
                                    'الكمية: ' +
                                        (product.availableQuantity != 'null'
                                            ? StringUtils()
                                                .oCcy
                                                .format(int.parse(product.availableQuantity.split('.')[0]))
                                            : ' '),
                                    style: mainStyle.copyWith(
                                        fontWeight: FontWeight.w700, color: primaryColor, fontSize: 13),
                                  ),
                                  if (product.alertProductsCount != 'null')
                                    RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: StringUtils().oCcy.format(int.parse(product.alertProductsCount)),
                                            style: mainStyle.copyWith(color: kmColors, fontSize: 14),
                                          ),
                                          TextSpan(
                                            text: 'ينتظرون تفعيل  المنتج',
                                            style: mainStyle.copyWith(color: kmColors, fontSize: 14),
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
                          if (supplierCode != null && active != null && id != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: SwitchProductStatusWidget(
                                isForSubWarehouse: true,
                                preState: active,
                                subWarehouseId: int.parse(id),
                                productId: product.id.toString(),
                                onChange: (int isActive, bool result) {
                                  if (result) active = isActive;
                                  onChangeStatus(result);
                                },
                                height: 58,
                                width: 69,
                              ),
                            ),
                          Row(
                            children: [
                              if (deleteTimes != -1)
                                Container(
                                  height: 58,
                                  width: 69,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                      border: Border.all(color: Colors.red, width: 2)),
                                  child: Center(child: Text(deleteTimes.toString(), style: loseStyle)),
                                ),
                              Container(
                                height: 58,
                                width: 69,
                                margin: const EdgeInsets.all(15.0),
                                padding: const EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                    border: Border.all(color: primaryColor, width: 2)),
                                child: attached && supplierCode != 'null' && !fromInventory
                                    ? IconButton(
                                        icon: const Icon(Icons.close_sharp, color: Colors.red),
                                        onPressed: () {
                                          String subWarehouseName = '';
                                          subWarehouseName = state.generalInformationState.subWarehouses
                                              .firstWhere((subWarehouse) => subWarehouse.id.toString() == id,
                                                  orElse: () => SubWarehouseModel(name: 'المستودع'))
                                              .name;
                                          showMyDialog(
                                            context: context,
                                            title: 'حذف منتج من المستودع',
                                            text: 'هل أنت متأكد أنك تريد إزالة ${product.name} من $subWarehouseName',
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
                                    : !fromInventory
                                        ? IconButton(
                                            icon: const Icon(Icons.add, color: Colors.green),
                                            onPressed: () {
                                              if (product.id == 0) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (screenContext) => Scaffold(
                                                        body: SafeArea(
                                                            child: StoreViewCategory(
                                                                scaffoldKey: scaffoldKey,
                                                                productName: product.name,
                                                                supplierCode: supplierCode,
                                                                forProductAdding: true))),
                                                  ),
                                                );
                                              } else {
                                                if (barcode == null) {
                                                  StoreProvider.of<AppState>(context).dispatch(SetBarcodeType(
                                                      barcodeRequestType: BarcodeRequestType.attachProduct));
                                                  StoreProvider.of<AppState>(context)
                                                      .dispatch(SetonIgnore(onIgnore: (barcode) async {
                                                    int param;
                                                    if (barcode == null) {
                                                      param = null;
                                                    } else {
                                                      param = int.parse(barcode);
                                                    }
                                                    Navigator.push(
                                                        scaffoldKey.currentContext,
                                                        MaterialPageRoute(
                                                            builder: (context) => AddProductsToSubWarehouse(
                                                                barcode: param, product: product)));
                                                  }));
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (screenContext) =>
                                                              BarcodeScannerPage(product: product)));
                                                } else {
                                                  Navigator.push(
                                                    scaffoldKey.currentContext,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddProductsToSubWarehouse(product: product)),
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
                                                  subWarehouseId: id,
                                                  productId: product.id.toString());
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
                                              if (result) onDelete(true);
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
        );
      },
    );
  }
}
