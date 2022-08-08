import 'package:flutter/material.dart';
import 'package:kammun_app/modules/cart/redux/cart_action.dart';
import 'package:kammun_app/modules/order/redux/order_action.dart';
import 'package:kammun_app/modules/payment/redux/payment_action.dart';
import '../../../core/core_importer.dart';
import '../../cart/view/cart_view.dart';
import '../../orders/redux/orders_action.dart';
import '../models/get_order_model.dart';
import '../services/order_services.dart';

Future<void> orderMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is SubmitOrder) {
    store.dispatch(StartLoading());
    try {
      OrderResponse orderResponse = await OrderServices.submitNewOrder(submitOrderModel: action.submitOrderModel);
      if (orderResponse != null) {
        if (!orderResponse.success && orderResponse.reason.contains('discontinued')) {
          store.dispatch(CatchError(
              errorMessage: orderResponse.message ??
                  'نأسف لحدوث ذلك ولكن المنطقة التي تحاول الطلب إليها متوقفة بشكل مؤقت يرجى المحاولة بعد قليل'));
        } else if (orderResponse.changedPriceProducts.isNotEmpty || orderResponse.inactiveProducts.isNotEmpty) {
          store.dispatch(ErrorCreatingOrder(
              inactiveProducts: orderResponse.inactiveProducts ?? [],
              changedPriceProducts: orderResponse.changedPriceProducts ?? [],
              cart: store.state.cartState.cartProducts));
        } else if (orderResponse.success) {
          store.dispatch(OrderSubmittedSuccessfully(orderResponse: orderResponse));
        } else {
          store.dispatch(CatchError(errorMessage: orderResponse.message ?? ' حدث خطأ أثناء إنشاء الطلب'));
        }
      } else {
        store.dispatch(CatchError(errorMessage: orderResponse.message ?? ' حدث خطأ أثناء إنشاء الطلب'));
      }
    } catch (e) {
      store.dispatch(CatchError(errorMessage: ' حدث خطأ أثناء إنشاء الطلب'));
    }
    store.dispatch(StopLoading());
  } else if (action is ErrorCreatingOrder) {
    List<ProductData> notActiveProducts = [];
    List<ProductData> priceProducts = [];

    for (int i = 0; i < action.cart.length; i++) {
      if (action.inactiveProducts.contains(action.cart[i].id.toString())) {
        notActiveProducts.add(action.cart[i]);
      }
      if (action.changedPriceProducts.map((product) => product.id).toList().contains(action.cart[i].id)) {
        priceProducts.add(action.cart[i].copyWith(
            newPrice: action.changedPriceProducts
                .firstWhere((product) => product.id == action.cart[i].id)
                .newPrice
                .toString()));
      }
    }
    store.dispatch(SetOrderProblemProducts(notActiveProducts: notActiveProducts, priceProducts: priceProducts));
    store.dispatch(Pop());
    store.dispatch(Push(routeName: OrderProblemView.routeName));
    store.dispatch(CatchError(errorMessage: 'تغييرات طرأت أثناء التسوق', viewError: false));
  } else if (action is OrderSubmittedSuccessfully) {
    store.dispatch(NoError());
    if (action.orderResponse.ePaymentInfo != null) {
      if (action.orderResponse.ePaymentInfo.paymentMethodInfo != null) {
        store.dispatch(SetRedirectBackUrl(
            redirectBackUrl: action.orderResponse.ePaymentInfo.paymentMethodInfo
                .firstWhere((info) => info.key == 'redirectBackUrl')
                .value));
        store.dispatch(Push(routeName: GoToBank.routeName));
      } else {
        store.dispatch(Push(routeName: ThankYouView.routeName));
      }
    } else {
      store.dispatch(Push(routeName: ThankYouView.routeName));
    }
    store.dispatch(ClearCart());
    store.dispatch(SetUpdateOrderId(orderId: -1));
  } else if (action is GetOrder) {
    GetOrderResponse order = await OrderServices.getOrder(orderId: action.orderId.toString());
    if (order != null) {
      if (action.forCart) {
        store.dispatch(SetUpdateOrder(order: order.order));
        if (action.goToCart) store.dispatch(PushAndReplace(routeName: CartView.routeName));
      } else {
        Navigator.push(
            navigatorKey.currentContext, MaterialPageRoute(builder: (context) => OrderInvoice(orderData: order)));
        store.dispatch(StopLoading());
      }
    } else {
      store.dispatch(CatchError(errorMessage: 'خطأ أثناء جلب الطلب يرجى المحاولة مرة أخرى'));
    }
  }
  next(action);
}
