import 'package:flutter/material.dart';
import 'package:kammun_app/modules/invoice/redux/invoice_action.dart';
import 'package:kammun_app/modules/invoice/services/invoice_services.dart';
import 'package:kammun_app/modules/order/models/submit_order_model.dart';
import 'package:rounded_expansion_tile/rounded_expansion_tile.dart';
import '../../delivery_method/view/choose_delivery_method_view.dart';
import '../../../core/core_importer.dart';
import '../../order/redux/order_action.dart';
import '../../order/services/order_services.dart';
import '../../orders/redux/orders_action.dart';

class InvoiceView extends StatefulWidget {
  static const String routeName = '/Invoice';

  const InvoiceView({Key key}) : super(key: key);

  @override
  _InvoiceViewState createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  TextEditingController notesController = TextEditingController();
  TextEditingController couponCodeController = TextEditingController();
  String finalCouponCode;

  @override
  void initState() {
    finalCouponCode = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    notesController.text = StoreProvider.of<AppState>(context).state.orderState.submitOrderModel.userNote;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        List<KeyValueModel> children = [];
        children.addAll(state.invoiceState.invoiceView.invoiceInfo);
        children.removeLast();
        return TemporaryLoading(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: const NormalAppBar(title: 'الفاتورة'),
            body: SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                            child: RoundedExpansionTile(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                              trailing: const Icon(Icons.arrow_drop_down_circle),
                              title: Row(
                                children: [
                                  Text('المنتجات المطلوبة' '   ', style: informationStyle),
                                  Text('( ${state.cartState.cartProducts.length} منتج )', style: disableStyle)
                                ],
                              ),
                              children: [HorizontalProducts(products: state.cartState.cartProducts)],
                            ),
                          ),
                          InvoiceCard(
                            info: state.deliveryMethodState
                                .deliveryMethods[state.deliveryMethodState.selectedDeliveryMethod].name,
                            title: 'طريقة التوصيل',
                            icon: Icons.access_time,
                            viewButton: state.deliveryMethodState.deliveryMethods.length > 1 &&
                                state.ordersState.updatedOrderId == -1,
                            onChange: () => chooseDeliveryMethod(
                                context: context, deliveryMethods: state.deliveryMethodState.deliveryMethods),
                          ),
                          InvoiceCard(
                            info: state.addressState.addresses[state.addressState.selectedIndex].supportedCityName,
                            title: StringUtils.address,
                            icon: Icons.location_on,
                            viewButton: state.ordersState.updatedOrderId == -1,
                            details: state.addressState.addresses[state.addressState.selectedIndex].street,
                            onChange: () => chooseAddress(context: context, addresses: state.addressState.addresses),
                            forAddress: true,
                          ),
                          InvoiceCard(
                            icon: Icons.payment,
                            title: 'طريقة الدفع',
                            viewButton:
                                state.paymentState.paymentMethods.length > 1 && state.ordersState.updatedOrderId == -1,
                            info: state.paymentState.paymentMethods[state.paymentState.selectedPaymentMethod].name,
                            onChange: () => choosePaymentMethod(
                                context: context, paymentMethods: state.paymentState.paymentMethods),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AddAddressTextField(
                                  autoFocus: false,
                                  maxLines: 1,
                                  labelText: StringUtils.notes,
                                  controller: notesController,
                                  onSubmitted: () => StoreProvider.of<AppState>(context)
                                      .dispatch(SaveOrderNote(note: notesController.text)),
                                  hintText: StringUtils.notes,
                                  onChanged: () {
                                    StoreProvider.of<AppState>(context)
                                        .dispatch(SaveOrderNote(note: notesController.text));
                                  },
                                ),
                                const SizedBox(height: 25),
                                if (state.ordersState.updatedOrderId == -1 && !state.invoiceState.showCancelCoupon)
                                  KOutlinedButton(
                                    height: 50,
                                    text: '+ أضف كود حسم',
                                    color: ColorUtils.kmColors,
                                    width: MediaQuery.of(context).size.width,
                                    onTap: () {
                                      showDialog(
                                        context: navigatorKey.currentContext,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('أضف كود حسم', style: informationStyle),
                                            content: KTextField(
                                              autoFocus: false,
                                              controller: couponCodeController,
                                              maxLines: 1,
                                              onSubmitted: () {
                                                StoreProvider.of<AppState>(context).dispatch(Pop());
                                                StoreProvider.of<AppState>(context)
                                                    .dispatch(UseCoupon(couponCode: couponCodeController.text));
                                                CheckInvoiceModel invoiceModel = state.invoiceState.invoice
                                                    .copyWith(couponCode: couponCodeController.text);
                                                StoreProvider.of<AppState>(context)
                                                    .dispatch(CheckInvoice(invoice: invoiceModel, showCancel: true));
                                                finalCouponCode = couponCodeController.text;
                                                couponCodeController.text = '';
                                              },
                                              hintText: 'أضف كود حسم',
                                            ),
                                            actions: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  KButton(
                                                    color: ColorUtils.primaryColor,
                                                    width: MediaQuery.of(context).size.width * 0.3,
                                                    onTap: () {
                                                      StoreProvider.of<AppState>(context).dispatch(Pop());
                                                      StoreProvider.of<AppState>(context)
                                                          .dispatch(UseCoupon(couponCode: couponCodeController.text));
                                                      CheckInvoiceModel invoiceModel = state.invoiceState.invoice
                                                          .copyWith(couponCode: couponCodeController.text);
                                                      StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(
                                                          CheckInvoice(invoice: invoiceModel, showCancel: true));
                                                      finalCouponCode = couponCodeController.text;
                                                      couponCodeController.text = '';
                                                    },
                                                    text: 'تطبيق',
                                                    // width: 140,
                                                  ),
                                                  KOutlinedButton(
                                                    onTap: () => StoreProvider.of<AppState>(context).dispatch(Pop()),
                                                    width: MediaQuery.of(context).size.width * 0.3,
                                                    color: ColorUtils.primaryColor,
                                                    text: 'إلغاء',
                                                  ),
                                                ],
                                              ),
                                            ],
                                            scrollable: true,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                if (state.ordersState.updatedOrderId == -1 && state.invoiceState.showCancelCoupon)
                                  KCard(
                                      radius: 6,
                                      color: ColorUtils.silverColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('كود الحسم', style: paragraphStyle),
                                              InkWell(
                                                child: Text('إلغاء', style: loseStyle),
                                                onTap: () {
                                                  StoreProvider.of<AppState>(navigatorKey.currentContext)
                                                      .dispatch(NoError());
                                                  StoreProvider.of<AppState>(navigatorKey.currentContext)
                                                      .dispatch(StartLoading());
                                                  StoreProvider.of<AppState>(navigatorKey.currentContext)
                                                      .dispatch(DoNotUseCoupon());
                                                  couponCodeController.text = '';
                                                  finalCouponCode = '';
                                                  StoreProvider.of<AppState>(navigatorKey.currentContext)
                                                      .dispatch(HideCancelCoupon());
                                                  CheckInvoiceModel invoiceModel =
                                                      state.invoiceState.invoice.copyWith(couponCode: '');
                                                  StoreProvider.of<AppState>(navigatorKey.currentContext)
                                                      .dispatch(CheckInvoice(invoice: invoiceModel));
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      )),
                                InvoiceInfoWidget(title: 'تفاصيل الفاتورة', children: children),
                                KCard(
                                  radius: 6,
                                  child: InvoiceRow(
                                    style: informationStyle.copyWith(color: ColorUtils.kmColors),
                                    children: state.invoiceState.invoiceView.invoiceInfo.last.info,
                                    title: state.invoiceState.invoiceView.invoiceInfo.last.key,
                                    info: StringUtils().oCcy.format(
                                        int.parse(state.invoiceState.invoiceView.invoiceInfo.last.value.split('.')[0])),
                                  ),
                                ),
                                state.invoiceState.invoiceView.paymentInfo != null
                                    ? InvoiceInfoWidget(
                                        title: 'تفاصيل الدفع', children: state.invoiceState.invoiceView.paymentInfo)
                                    : const SizedBox(height: 25),
                              ],
                            ),
                          ),
                          if (int.parse(state.startupState.startModel.user.balance.split('.')[0]) > 0 &&
                              state.startupState.startModel.company.useWallet == 1 &&
                              state.ordersState.updatedOrderId == -1)
                            KCard(
                              radius: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    LabelRow(
                                        rightSideText: 'رصيد الحسومات: ',
                                        leftSideText: (state.invoiceState.invoice.useWallet == 0
                                                ? StringUtils().oCcy.format(
                                                    int.parse(state.startupState.startModel.user.balance.split('.')[0]))
                                                : StringUtils().oCcy.format(int.parse(
                                                        state.startupState.startModel.user.balance.split('.')[0]) -
                                                    int.parse(state.orderState.submitOrderModel.invoice.walletDiscount
                                                        .split('.')[0]))) +
                                            ' ' +
                                            state.startupState.startModel.company.currency,
                                        leftSideStyle:
                                            int.parse(state.startupState.startModel.user.balance.split('.')[0])
                                                    .isNegative
                                                ? loseStyle
                                                : informationStyle),
                                    state.invoiceState.invoice.useWallet == 0
                                        ? Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 15),
                                              child: KButton(
                                                color: ColorUtils.primaryColor,
                                                height: 50,
                                                onTap: () {
                                                  StoreProvider.of<AppState>(context).dispatch(StartLoading());
                                                  StoreProvider.of<AppState>(context).dispatch(UseWallet());
                                                  CheckInvoiceModel invoiceModel =
                                                      state.invoiceState.invoice.copyWith(useWallet: 1);
                                                  StoreProvider.of<AppState>(context)
                                                      .dispatch(CheckInvoice(invoice: invoiceModel));
                                                },
                                                text: 'استخدام',
                                              ),
                                            ),
                                          )
                                        : Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 15),
                                              child: KOutlinedButton(
                                                onTap: () {
                                                  StoreProvider.of<AppState>(context).dispatch(StartLoading());
                                                  StoreProvider.of<AppState>(context).dispatch(DoNotUseWallet());
                                                  CheckInvoiceModel invoiceModel =
                                                      state.invoiceState.invoice.copyWith(useWallet: 0);
                                                  StoreProvider.of<AppState>(context)
                                                      .dispatch(CheckInvoice(invoice: invoiceModel));
                                                },
                                                height: 50,
                                                color: ColorUtils.primaryColor,
                                                text: 'إلغاء',
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                    KCard(
                      radius: 0,
                      color: ColorUtils.silverColor,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20, top: 10, right: 10, left: 10),
                        child: KButton(
                          color: ColorUtils.primaryColor,
                          onTap: () {
                            if (state.ordersState.updatedOrderId != -1) {
                              StoreProvider.of<AppState>(context).dispatch(UpdateOrder(
                                  submitOrderModel: SubmitOrderModel(
                                invoice: state.orderState.submitOrderModel.invoice,
                                purchasePrices: state.cartState.subtotal,
                                userNote: state.orderState.submitOrderModel.userNote,
                                deliveryMethodId: state.deliveryMethodState
                                    .deliveryMethods[state.deliveryMethodState.selectedDeliveryMethod].id,
                                products: OrderServices.convertCartProductToInvoiceProduct(
                                    cartProducts: state.cartState.cartProducts),
                              )));
                            } else {
                              SubmitOrderModel model = SubmitOrderModel(
                                invoice: state.orderState.submitOrderModel.invoice,
                                purchasePrices: state.cartState.subtotal,
                                useWallet: state.invoiceState.invoice.useWallet,
                                couponCode: state.invoiceState.showCancelCoupon ? finalCouponCode : '',
                                userNote: state.orderState.submitOrderModel.userNote,
                                paymentMethodId:
                                    state.paymentState.paymentMethods[state.paymentState.selectedPaymentMethod].id,
                                supportedCityId: state.startupState.startModel.user.supportedCityId,
                                deliveryMethodId: state.deliveryMethodState
                                    .deliveryMethods[state.deliveryMethodState.selectedDeliveryMethod].id,
                                addressId: state.addressState.addresses[state.addressState.selectedIndex].id,
                                products: OrderServices.convertCartProductToInvoiceProduct(
                                    cartProducts: state.cartState.cartProducts),
                              );
                              Map<String, String> map = InvoiceServices.checkDate();
                              if (map.values.first.contains('d')) {
                                StoreProvider.of<AppState>(context).dispatch(SubmitOrder(submitOrderModel: model));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OutSideWorkingHours(
                                            model: model, message: map.keys.first, time: map.values.first)));
                              }
                            }
                          },
                          width: MediaQuery.of(context).size.width,
                          text: StringUtils.confirmOrder,
                          height: 50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
