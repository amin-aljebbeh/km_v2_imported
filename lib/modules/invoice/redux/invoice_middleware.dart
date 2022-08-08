import 'package:kammun_app/modules/invoice/redux/invoice_action.dart';
import 'package:kammun_app/modules/invoice/services/invoice_services.dart';
import 'package:kammun_app/modules/order/redux/order_action.dart';
import 'package:kammun_app/modules/startup/redux/startup_action.dart';

import '../../../core/core_importer.dart';
import '../../cart/redux/cart_action.dart';

Future<void> invoiceMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is CheckInvoice) {
    store.dispatch(StartLoading());
    var var1 = await InvoiceServices.checkOrderInvoice(invoiceModel: action.invoice);

    if (var1 != null) {
      if (var1.success) {
        InvoiceModel invoiceModel = var1.data.invoice;
        store.dispatch(SetOrderInvoice(invoiceModel: invoiceModel));
        store.dispatch(SetBalance(balance: var1.data.userBalance));
        store.dispatch(SetInvoiceView(
            invoiceView:
                InvoiceViewWidgetModel(invoiceInfo: var1.data.invoiceInfo, paymentInfo: var1.data.paymentInfo)));
        if (action.goToInvoice) {
          store.dispatch(Push(routeName: InvoiceView.routeName));
        }
        if (action.showCancel) store.dispatch(ShowCancelCoupon());
      } else {
        if (var1.changedPriceProducts.isNotEmpty || var1.inactiveProducts.isNotEmpty) {
          store.dispatch(ErrorCreatingOrder(
              changedPriceProducts: var1.changedPriceProducts,
              inactiveProducts: var1.inactiveProducts,
              cart: store.state.cartState.cartProducts));
        } else {
          if (var1.statusCode == 410) {
            store.dispatch(HideCancelCoupon());
            store.dispatch(DoNotUseCoupon());
            store.dispatch(CheckInvoice(invoice: action.invoice.copyWith(couponCode: '')));
          }
          store.dispatch(CatchError(
              errorMessage: var1.message ?? 'حدث خطأ يرجى المحاولة مجدداً',
              reason: var1.reason ?? var1.message ?? 'حدث خطأ يرجى المحاولة مجدداً'));
        }
      }
    } else {
      store.dispatch(CatchError(errorMessage: 'حدث خطأ يرجى المحاولة مجدداً', reason: 'some thing went wrong'));
    }
    store.dispatch(StopLoading());
  } else if (action is UseCoupon) {
    store.dispatch(SaveCoupon(coupon: action.couponCode));
  } else if (action is CheckInvoiceOnUpdate) {
    store.dispatch(StartLoading());
    var var1 = await InvoiceServices.checkOrderInvoiceOnUpdate(invoiceModel: action.invoice, orderId: action.orderId);

    if (var1 != null) {
      if (var1.success) {
        InvoiceModel invoiceModel = var1.data.invoice;
        store.dispatch(SetOrderInvoice(invoiceModel: invoiceModel));
        store.dispatch(SetInvoiceView(
            invoiceView:
                InvoiceViewWidgetModel(invoiceInfo: var1.data.invoiceInfo, paymentInfo: var1.data.paymentInfo)));
        store.dispatch(Push(routeName: InvoiceView.routeName));
      } else {
        if (var1.changedPriceProducts.isNotEmpty || var1.inactiveProducts.isNotEmpty) {
          store.dispatch(ErrorCreatingOrder(
              changedPriceProducts: var1.changedPriceProducts,
              inactiveProducts: var1.inactiveProducts,
              cart: store.state.cartState.cartProducts));
        } else {
          if (var1.statusCode == 410) {
            store.dispatch(ShowCartCancelCoupon());
          }
          store.dispatch(CatchError(
              errorMessage: var1.message ?? 'حدث خطأ يرجى المحاولة مجدداً',
              reason: var1.reason ?? var1.message ?? 'حدث خطأ يرجى المحاولة مجدداً'));
        }
      }
    } else {
      store.dispatch(CatchError(errorMessage: 'حدث خطأ يرجى المحاولة مجدداً', reason: 'some thing went wrong'));
    }
    store.dispatch(StopLoading());
  } else if (action is CancelCoupon) {
    await InvoiceServices.cancelCoupon(orderId: action.orderId.toString());
    store.dispatch(StopLoading());
    store.dispatch(HideCartCancelCoupon());
  }
  next(action);
}
