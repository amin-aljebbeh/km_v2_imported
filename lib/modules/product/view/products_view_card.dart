import 'package:flutter/material.dart';
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/modules/product/redux/product_action.dart';
import 'package:kammun_app/modules/product/view/product_detail_view.dart';

import '../../cart/redux/cart_action.dart';
import '../service/product_service.dart';
import 'choose_alert_type_view.dart';

class ProductsViewCard extends StatefulWidget {
  final int index;
  final bool lastProduct;
  final ProductData product;

  const ProductsViewCard({Key key, this.index, this.product, this.lastProduct}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProductsViewCardState();
  }
}

class ProductsViewCardState extends State<ProductsViewCard> {
  int productCount;
  @override
  void initState() {
    productCount = widget.product.productCount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                if (widget.product.isActive == '1' && state.productsState.productsType != ProductsViewTypes.alert) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailView(
                          product: widget.product,
                          initialCount: state.cartState.cartProducts
                              .firstWhere((product) => product.id == widget.product.id,
                                  orElse: () => ProductData(productCount: 1))
                              .productCount),
                    ),
                  );
                } else {
                  if (widget.product.alertId == 'null') {
                    widget.product.productAlert == null
                        ? ProductService.notifyMeDialog(productId: widget.product.id, productName: widget.product.name)
                        : ProductService.doNotNotifyMeDialog(
                            alertId: widget.product.productAlert.id,
                            productName: widget.product.name,
                            productId: widget.product.id);
                  }
                }
              },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Row(
                      children: <Widget>[
                        Stack(
                          children: [
                            KCacheImage(
                              blur: widget.product.isActive == '0',
                              tag: widget.product.id,
                              image: widget.product.images.isNotEmpty ? widget.product.images[0].imageFileName : '',
                              fromFavorite: state.productsState.productsType == ProductsViewTypes.favorite,
                            ),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Wrap(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Wrap(
                                    children: <Widget>[
                                      Text(
                                        widget.product.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontFamily: StringUtils.fontFamily,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    widget.product.unit.toString() != 'null'
                                        ? widget.product.quantity + ' ' + widget.product.unit.toString()
                                        : widget.product.quantity,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: ColorUtils.greyColor,
                                        fontFamily: StringUtils.fontFamily,
                                        fontSize: 15),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    StringUtils()
                                            .oCcy
                                            .format(int.parse(widget.product.price.split('.')[0]))
                                            .toString() +
                                        ' ${state.startupState.startModel.company.currency}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: ColorUtils.primaryColor,
                                        fontFamily: StringUtils.fontFamily,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (widget.product.isActive == '0' ||
                            (state.productsState.productsType == ProductsViewTypes.alert))
                          Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: KOutlinedButton(
                              color: widget.product.productAlert != null || widget.product.alertId != 'null'
                                  ? Colors.red
                                  : ColorUtils.kmColors2,
                              text: widget.product.productAlert != null || widget.product.alertId != 'null'
                                  ? 'إلغاء الإشعار'
                                  : 'أعلمني عند توافره',
                              width: MediaQuery.of(context).size.width * 0.3,
                              onTap: () {
                                if (widget.product.alertId != 'null') {
                                  StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(StartLoading());
                                  StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(DoNotNotifyMe(
                                      alertId: int.parse(widget.product.alertId), productId: widget.product.id));
                                } else {
                                  if (widget.product.productAlert == null) {
                                    chooseAlertType(context: navigatorKey.currentContext, productId: widget.product.id);
                                  } else {
                                    StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(StartLoading());
                                    StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(DoNotNotifyMe(
                                        alertId: widget.product.productAlert.id, productId: widget.product.id));
                                  }
                                }
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (widget.product.isActive == '1' && state.productsState.productsType != ProductsViewTypes.alert)
                    Positioned(
                      top: 7,
                      right: 7,
                      child: ProductCounter(
                        productId: widget.product.id,
                        onAdd: () {
                          flushbar(
                              message: 'تم إضافة ${widget.product.name} لسلة المشتريات',
                              color: Colors.green,
                              icon: Icons.shopping_cart);
                          ProductData product = widget.product;
                          product.productCount = 1;
                          StoreProvider.of<AppState>(context)
                              .dispatch(AddProductToCart(product: product, context: context, sync: true));
                          StoreProvider.of<AppState>(context).dispatch(CalculateSubTotal());
                          StoreProvider.of<AppState>(context).dispatch(CheckLimitTotalCost());
                        },
                        onRemove: (count) {
                          StoreProvider.of<AppState>(context)
                              .dispatch(UpdateCartProduct(count: count, productId: widget.product.id));
                          StoreProvider.of<AppState>(context).dispatch(CalculateSubTotal());
                        },
                        onDelete: () {
                          StoreProvider.of<AppState>(context).dispatch(RemoveProduct(productId: widget.product.id));
                          StoreProvider.of<AppState>(context).dispatch(CalculateSubTotal());
                        },
                        onIncrease: (count) {
                          if (!(widget.product.maxCount.contains('-') || widget.product.maxCount == '0') &&
                              int.parse(widget.product.maxCount.replaceAll('-', '').split('.')[0]) < count) {
                            flushbar(
                                message: 'لا يمكن إضافة المزيد من ${widget.product.name} لعدم وجود كمية كافية',
                                color: Colors.red,
                                icon: Icons.error);
                          } else {
                            flushbar(
                                message: 'تم إضافة ${widget.product.name} لسلة المشتريات',
                                color: Colors.green,
                                icon: Icons.shopping_cart);
                            StoreProvider.of<AppState>(context)
                                .dispatch(UpdateCartProduct(count: count, productId: widget.product.id));
                            StoreProvider.of<AppState>(context).dispatch(CalculateSubTotal());
                            StoreProvider.of<AppState>(context).dispatch(CheckLimitTotalCost());
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
            if (widget.lastProduct)
              Padding(padding: EdgeInsets.only(top: 8, left: 15, right: 15), child: EndOfPageWidget()),
          ],
        );
      },
    );
  }
}
