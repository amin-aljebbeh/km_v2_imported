import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/modules/cart/service/cart_services.dart';
import 'package:kammun_app/modules/cart/view/cart_view.dart';
import 'package:kammun_app/modules/payment/redux/payment_action.dart';
import '../../invoice/redux/invoice_action.dart';
import '../../order/services/order_services.dart';
import '../models/payment_method_model.dart';
import '../services/payment_services.dart';

Future<void> paymentMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is GetPaymentMethods) {
    List<PaymentMethodModel> paymentMethods = await PaymentServices.getPaymentMethods();
    if (paymentMethods != null) {
      store.dispatch(PaymentMethodsFetchedSuccessfully(paymentMethods: paymentMethods));
    } else {
      store.dispatch(CatchError(errorMessage: 'حدث خطأ يرجة إعادة المحاولة'));
    }
  } else if (action is SelectPaymentMethod) {
    store.dispatch(SetPaymentMethodId(
        paymentMethodId: store.state.paymentState.paymentMethods.elementAt(action.selectedPaymentMethod).id));
  } else if (action is CheckPayment) {
    OrdersOriginalData order = (await OrderServices.getOrder(orderId: action.orderId)).order;

    if (order != null) {
      store.dispatch(SaveOrder(order: order));
      switch (order.orderStatusId) {
        case '1':
          store.dispatch(Push(routeName: ThankYouView.routeName));
          break;
        case '8':
          store.dispatch(Push(routeName: WaitingPaymentView.routeName));
          break;
        case '9':
          store.dispatch(Push(routeName: PaymentFailedView.routeName));
          break;
      }
    }
  } else if (action is RetryPayment) {
    CartServices.moveOrderProductsToCart(order: action.order);
    store.dispatch(Push(routeName: CartView.routeName));
  }
  next(action);
}
