import 'package:kammun_app/features/general_information/data/models/warehouse_model.dart';
import 'package:kammun_app/features/product_details/presentation/widgets/change_product_category_and_sub_warehouse_widget.dart';
import 'package:kammun_app/features/product_details/presentation/widgets/delete_product_image_widget.dart';
import 'package:kammun_app/features/product_details/presentation/widgets/product_options_widget.dart';
import 'package:kammun_app/features/product_details/presentation/widgets/remove_from_warehouse.dart';
import 'package:kammun_app/features/products/domain/entities/product_entity.dart';
import 'package:kammun_app/features/products_view/services/products_services.dart';

import '../../../../core/core_importer.dart';
import '../widgets/add_to_cart_widget.dart';
import '../widgets/product_categories_widget.dart';
import '../widgets/product_details_view_app_bar.dart';
import '../widgets/product_general_info_widget.dart';
import '../widgets/product_sub_warehouse_info_widget.dart';
import '../widgets/product_warehouses_widget.dart';
import '../widgets/remove_product_widget.dart';

class ProductDetailView extends StatefulWidget {
  final ProductEntity product;
  final int productId;
  final Function(String) onAddBarcode;
  final Function(String) onChangePrice;
  final Function(String) onChangePriceFactor;
  final Function(String) onChangeUnit;
  final Function(String) onChangeQuantity;
  final Function(String) onChangeSubWarehouse;

  const ProductDetailView({
    Key key,
    this.product,
    this.onAddBarcode,
    this.onChangePrice,
    this.onChangeUnit,
    this.onChangeQuantity,
    this.onChangeSubWarehouse,
    this.onChangePriceFactor,
    this.productId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProductDetailViewState();
}

class ProductDetailViewState extends State<ProductDetailView> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final _controller = ScrollController(initialScrollOffset: 0.0);

  @override
  void initState() {
    if (widget.product.warehouses.isEmpty) {
      widget.product.warehouses.add(WarehouseModel(name: 'غير مضاف لمستودع', id: 0));
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool isError = false;

  String selectedValueCategoryValue;
  String productSubWarehouseId;

  @override
  Widget build(BuildContext context) {
    ProductEntity product = widget.product;
    String price = product.price;
    if (Services.hasRole(context, supplierRole)) {
      price = (int.parse(product.price.split('.')[0]) - product.increasePercentage).toString();
    }
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return SafeArea(
          key: scaffoldKey,
          top: true,
          left: false,
          right: false,
          bottom: true,
          child: Scaffold(
            backgroundColor: Theme.of(context).primaryColorLight,
            body: NestedScrollView(
              controller: _controller,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
                  <Widget>[ProductDetailsViewAppBar(product: product, scrollController: _controller)],
              body: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 25),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0))),
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Center(
                            child: Padding(
                                padding: const EdgeInsets.only(bottom: 18, top: 8, right: 8, left: 8),
                                child: Text(product.name,
                                    style: mainStyle.copyWith(
                                        fontWeight: FontWeight.bold, color: primaryColor, fontSize: 25)))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text(quantityString + ' :', style: paragraphStyle),
                                ),
                                Text(
                                    product.unit.toString() != 'null'
                                        ? product.quantity.toString() + ' ' + product.unit.toString()
                                        : product.quantity.toString(),
                                    style: informationStyle),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text(priceString + ' :', style: paragraphStyle),
                                ),
                                Text(
                                    StringUtils().oCcy.format(int.parse(price.split('.')[0])) +
                                        state.generalInformationState.companyInformation.currency,
                                    style: informationStyle),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Center(
                            child: LabelRow(
                                rightSideText: 'ProductId : ',
                                leftSideText: widget.productId.toString(),
                                leftSideStyle: informationStyle),
                          ),
                        ),
                        LabelRow(
                            rightSideText: descriptionString + ' :',
                            leftSideText: product.description != null ? product.description.split('@')[0] : '',
                            leftSideStyle: informationStyle),
                        ProductCategoriesWidget(
                            product: product, onRemove: (index) => setState(() => product.categories.removeAt(index))),
                        if (Services.hasRole(context, productsControllerRole))
                          ProductWarehousesWidget(warehouses: product.warehouses),
                        AddToCartWidget(product: product),
                        if (Services.hasRole(context, productsControllerRole) ||
                            Services.hasRole(context, adminRole) ||
                            (state.generalInformationState.subWarehouses
                                .any((element) => element.id == product.subWarehouseId)))
                          Column(
                            children: [
                              ProductSubWarehouseInfoWidget(
                                  product: product,
                                  onChangePrice: (price) {
                                    setState(() => product.price = price);
                                    widget.onChangePrice(price);
                                  },
                                  onChangePriceFactor: (priceFactor) => widget.onChangePriceFactor(priceFactor)),
                              Services.hasPermission(context, upDateProductPermission) ||
                                      (state.generalInformationState.subWarehouses
                                          .any((element) => element.id == product.subWarehouseId))
                                  ? Padding(
                                      padding: const EdgeInsets.only(bottom: 30),
                                      child: Column(
                                        children: [
                                          ProductGeneralInfoWidget(
                                              product: product,
                                              onChangeQuantity: (quantity) => widget.onChangeQuantity(quantity),
                                              onChangeUnit: (unit) => widget.onChangeUnit(unit)),
                                          ChangeProductCategoryAndSubWarehouseWidget(
                                              product: product,
                                              onChangeCategory: (category) => selectedValueCategoryValue = category,
                                              onChangeSubWarehouse: (subWarehouse) =>
                                                  widget.onChangeSubWarehouse(subWarehouse)),
                                          DeleteProductImageWidget(
                                              product: product,
                                              onAdd: () async => await ProductsServices.updateProductsDetails(
                                                  bodyKey: 'category_id',
                                                  value: selectedValueCategoryValue,
                                                  productId: product.productId.toString()),
                                              onDone: () => setState(() => product.categories.add(
                                                  state.generalInformationState.categories.firstWhere((category) =>
                                                      category.id.toString() == selectedValueCategoryValue)))),
                                          ProductOptionsWidget(
                                              product: product,
                                              scaffoldKey: scaffoldKey,
                                              onAddBarcode: (code) => widget.onAddBarcode(code)),
                                          if (Services.hasRole(context, adminRole) ||
                                              Services.hasRole(context, productsControllerRole))
                                            RemoveProductWidget(product: product),
                                        ],
                                      ),
                                    )
                                  : Services.hasRole(context, supplierRole) &&
                                          (state.generalInformationState.subWarehouses
                                              .any((element) => element.id == product.subWarehouseId))
                                      ? RemoveFromWarehouse(product: product)
                                      : Container(),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
