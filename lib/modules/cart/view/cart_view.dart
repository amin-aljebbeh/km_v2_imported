import 'package:flutter/material.dart';
import 'package:kammun_app/modules/cart/view/cart_card.dart';
import 'package:kammun_app/modules/order/services/order_services.dart';
import '../../../core/core_importer.dart';
import '../../invoice/redux/invoice_action.dart';
import '../../payment/redux/payment_action.dart';
import '../../supported_city/redux/supported_city_action.dart';
import '../redux/cart_action.dart';
import '../service/cart_services.dart';

class CartView extends StatefulWidget {
  static const String routeName = '/CartView';

  const CartView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CartViewState();
  }
}

class CartViewState extends State<CartView> {
  List<ProductData> orderArray = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(StopLoading());
      orderArray.addAll(StoreProvider.of<AppState>(context).state.cartState.cartProducts);
      StoreProvider.of<AppState>(context).dispatch(CalculateSubTotal());
      if (StoreProvider.of<AppState>(context).state.ordersState.updatedOrderId != -1) {
        CartServices.updateOrderDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: const NormalAppBar(title: 'السلة', pop: false),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (state.cartState.cartProducts.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
                    child: Center(
                      child: Text(
                        'سلة المشتريات فارغة',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: ColorUtils.greyColor,
                          fontFamily: StringUtils.fontFamily,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    itemCount: orderArray.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
                        child: CartCard(
                          count: orderArray[index].productCount,
                          product: orderArray[index],
                          hero: index,
                          onAdd: () {
                            if (!(orderArray[index].maxCount.contains('-') || orderArray[index].maxCount == '0') &&
                                int.parse(orderArray[index].maxCount.replaceAll('-', '').split('.')[0]) <
                                    orderArray[index].productCount + 1) {
                              flushbar(
                                  message: 'لا يمكن إضافة المزيد من ${orderArray[index].name} لعدم وجود كمية كافية',
                                  color: Colors.red,
                                  icon: Icons.shopping_cart);
                            } else {
                              orderArray[index].productCount += 1;
                              StoreProvider.of<AppState>(context).dispatch(SaveCart(cartProducts: orderArray));
                              StoreProvider.of<AppState>(context).dispatch(CalculateSubTotal());
                              StoreProvider.of<AppState>(context).dispatch(CheckLimitTotalCost());
                            }
                          },
                          onRemove: () {
                            orderArray[index].productCount--;
                            StoreProvider.of<AppState>(context).dispatch(SaveCart(cartProducts: orderArray));
                            StoreProvider.of<AppState>(context).dispatch(CalculateSubTotal());
                          },
                          onDelete: () {
                            StoreProvider.of<AppState>(context)
                                .dispatch(RemoveProduct(productId: orderArray[index].id));
                            StoreProvider.of<AppState>(context).dispatch(CalculateSubTotal());
                            orderArray.removeAt(index);
                          },
                        ),
                      );
                    },
                  ),
                ),
                KCard(
                  radius: 0,
                  color: ColorUtils.silverColor,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(StringUtils.total, style: informationStyle),
                              Text(
                                '${StringUtils().oCcy.format(state.cartState.subtotal)} ${state.startupState.startModel.company.currency}',
                                style: paragraphStyle,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        KButton(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          color: ColorUtils.primaryColor,
                          onTap: () {
                            if (state.cartState.cartProducts.isNotEmpty) {
                              if (state.addressState.addresses.isNotEmpty) {
                                if (state.startupState.startModel.user.limitTotalCost > state.cartState.subtotal) {
                                  StoreProvider.of<AppState>(context).dispatch(HideCancelCoupon());
                                  if (state.ordersState.updatedOrderId == -1) {
                                    int useWallet = 0;
                                    if (state.startupState.startModel.company.useWallet == 1) {
                                      if (int.parse(state.startupState.startModel.user.balance.split('.')[0])
                                          .isNegative) {
                                        StoreProvider.of<AppState>(context).dispatch(UseWallet());
                                        useWallet = 1;
                                      } else {
                                        StoreProvider.of<AppState>(context).dispatch(DoNotUseWallet());
                                        useWallet = 0;
                                      }
                                    } else {
                                      StoreProvider.of<AppState>(context).dispatch(DoNotUseWallet());
                                      useWallet = 0;
                                    }
                                    StoreProvider.of<AppState>(context)
                                        .dispatch(SelectPaymentMethod(selectedPaymentMethod: 0));
                                    CheckInvoiceModel invoiceModel = CheckInvoiceModel(
                                      purchasePrices: state.cartState.subtotal,
                                      useWallet: useWallet,
                                      paymentMethodId: state
                                          .paymentState.paymentMethods[state.paymentState.selectedPaymentMethod].id,
                                      supportedCityId: state.startupState.startModel.user.supportedCityId,
                                      deliveryMethodId: state.deliveryMethodState
                                          .deliveryMethods[state.deliveryMethodState.selectedDeliveryMethod].id,
                                      addressId: state.addressState.addresses[state.addressState.selectedIndex].id,
                                      products: OrderServices.convertCartProductToInvoiceProduct(
                                          cartProducts: state.cartState.cartProducts),
                                    );
                                    StoreProvider.of<AppState>(context)
                                        .dispatch(SetInvoice(invoiceModel: invoiceModel));
                                    StoreProvider.of<AppState>(context)
                                        .dispatch(CheckInvoice(goToInvoice: true, invoice: invoiceModel));
                                  } else {
                                    CheckInvoiceModel invoiceModel = CheckInvoiceModel(
                                      purchasePrices: state.cartState.subtotal,
                                      products: OrderServices.convertCartProductToInvoiceProduct(
                                          cartProducts: state.cartState.cartProducts),
                                    );
                                    StoreProvider.of<AppState>(context)
                                        .dispatch(SetInvoice(invoiceModel: invoiceModel));
                                    StoreProvider.of<AppState>(context).dispatch(CheckInvoiceOnUpdate(
                                        invoice: invoiceModel, orderId: state.ordersState.updatedOrderId.toString()));
                                  }
                                } else {
                                  showMyDialog(
                                      title: 'لا يمكن الاستمرار',
                                      dialogButtons: [const CloseWidget()],
                                      text: 'إن قيمة المنتجات التي تحاول طلبها تتجاوز الحد الأعلى المسموح به ' +
                                          StringUtils().oCcy.format(state.startupState.startModel.user.limitTotalCost) +
                                          ' ' +
                                          state.startupState.startModel.company.currency);
                                }
                              } else {
                                showMyDialog(
                                    title: 'ليس لديك أي عنوان',
                                    text: 'يرجى إضافة عنوان لتوصيل الطلب إليه',
                                    dialogButtons: [
                                      KButton(
                                          width: MediaQuery.of(context).size.width,
                                          color: ColorUtils.primaryColor,
                                          text: StringUtils.addNewAddress,
                                          onTap: () {
                                            StoreProvider.of<AppState>(context).dispatch(Pop());
                                            StoreProvider.of<AppState>(context).dispatch(StartLoading());
                                            StoreProvider.of<AppState>(context).dispatch(GetSupportedCities());
                                          })
                                    ]);
                              }
                            } else {
                              flushbar(
                                  message: 'يرجى إضافة منتج واحد على الأقل',
                                  color: Colors.red,
                                  icon: Icons.error,
                                  duration: 2);
                            }
                          },
                          text: 'متابعة',
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
