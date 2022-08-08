import 'package:in_app_review_play_store/in_app_review_play_store.dart';
import 'package:kammun_app/modules/orders/redux/orders_action.dart';
import 'package:kammun_app/modules/orders/services/orders_services.dart';
import 'package:kammun_app/modules/orders/view/orders_view.dart';
import '../../../core/core_importer.dart';
import '../../address/redux/address_action.dart';
import '../../cart/redux/cart_action.dart';
import '../../cart/service/cart_services.dart';
import '../../delivery_method/redux/delivery_method_action.dart';
import '../../order/redux/order_action.dart';
import '../../payment/redux/payment_action.dart';

Future<void> ordersMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is GetOrders) {
    store.dispatch(StartLoading());
    store.dispatch(NoError());
    List<OrdersOriginalData> orders = await OrdersServices.getMyOrders();
    if (orders != null) {
      store.dispatch(OrdersFetchedSuccessfully(orders: orders));
      store.dispatch(NoError());
    } else {
      store.dispatch(CatchError(errorMessage: 'خطأ في جلب الطلبات'));
    }
    store.dispatch(StopLoading());
  } else if (action is CancelOrder) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String updateId = prefs.getString('orderUnderUpdateId');
    if (action.orderId == updateId) {
      prefs.setString('orderUnderUpdateId', '-1');
      store.dispatch(ClearCart());
      store.dispatch(SetUpdateOrder(order: OrdersOriginalData(id: -1)));
      store.dispatch(SetUpdateOrderId(orderId: -1));
    }
    bool result = await OrdersServices.cancelOrderService(orderId: action.orderId);
    if (result) {
      store.dispatch(GetOrders());
    } else {
      store.dispatch(CatchError(
          errorMessage:
              'تم قبول طلبك مسبقاً لا يمكن إلغاء الطلب حاليا اذا كنت مصرَاً على إلغاء الطلب يرجى التواصل مع فريق الدعم'));
    }
  } else if (action is UpdateOrder) {
    store.dispatch(StartLoading());
    try {
      OrderResponse orderResponse = await OrdersServices.updateOrder(
          submitOrderModel: action.submitOrderModel, orderId: store.state.ordersState.updatedOrderId.toString());
      if (orderResponse != null) {
        if (!orderResponse.success && orderResponse.reason.contains('discontinued')) {
          store.dispatch(CatchError(
              errorMessage: orderResponse.message ??
                  'نأسف لحدوث ذلك ولكن المنطقة التي تحاول الطلب إليها متوقفة بشكل مؤقت يرجى المحاولة بعد قليل'));
        } else if (orderResponse.changedPriceProducts.isNotEmpty || orderResponse.inactiveProducts.isNotEmpty) {
          store.dispatch(ErrorCreatingOrder(
              inactiveProducts: orderResponse.inactiveProducts,
              changedPriceProducts: orderResponse.changedPriceProducts,
              cart: store.state.cartState.cartProducts));
        } else if (orderResponse.success) {
          store.dispatch(OrderSubmittedSuccessfully(orderResponse: orderResponse));
          store.dispatch(ClearCart());
        } else if (!orderResponse.success) {
          store.dispatch(CatchError(errorMessage: orderResponse.message ?? 'حدث خطأ أثناء تعديل الطلب'));
        }
      } else {
        store.dispatch(CatchError(errorMessage: 'حدث خطأ أثناء تعديل الطلب'));
      }
    } catch (e) {
      store.dispatch(CatchError(errorMessage: 'حدث خطأ أثناء تعديل الطلب'));
    }
    store.dispatch(StopLoading());
  } else if (action is RateOrder) {
    store.dispatch(StartLoading());
    bool response = await OrdersServices.rateOrderService(
        orderId: action.orderId, userFeedback: action.userFeedback + '.', rating: action.rating);
    if (response) {
      store.dispatch(Pop());
      store.dispatch(GetOrders());
      if (action.rating == 5.0) {
        InAppReview.launch();
      }
    } else {
      store.dispatch(CatchError(
          errorMessage: 'حدث خطأ أثناء محاولة إرسال التقييم يرجى التحقق من إتصالك بالإنترنت و المحاولة مجددا'));
    }
    store.dispatch(PushAndReplace(routeName: OrdersView.routeName));
    store.dispatch(StopLoading());
  } else if (action is LockOrder) {
    store.dispatch(StartLoading());
    try {
      String response = await OrdersServices.lockOrderService(orderId: action.orderId.toString());
      switch (response) {
        case 'null':
          store.dispatch(CatchError(errorMessage: 'حدث خطأ أثناء محاولة تعديل الطلب يرجى التأكد من إتصالك بالإنترنت'));
          break;
        case 'true':
          store.dispatch(NoError());
          store.dispatch(GetOrder(forCart: true, orderId: action.orderId, goToCart: true));
          break;
        case 'admin':
          store.dispatch(CatchError(errorMessage: 'لا يمكنك تعديل طلبك حالياً لأن مسؤول الطلب يقوم بتعديله حالياً'));
          break;
        case 'Another':
          store.dispatch(CatchError(
              errorMessage:
                  'لا يمكنك تعديل طلبك حالياً لأنه بالفعل لديك طلب آخر قيد التعديل يرجى الإنتهاء من تعديل الطلب السابق و المحاولة من جديد'));
          break;
        case 'false':
          store.dispatch(CatchError(
              errorMessage:
                  'حدث خطأ أثناء محاولة تعديل الطلب يرجى التأكد من إتصالك بالإنترنت لا يمكنك تعديل طلبك حالياً لانه تم الإنتهاء من تطبيق طلبك بنجاح'));
          break;
      }
    } catch (e) {
      store.dispatch(CatchError(errorMessage: 'حدث خطأ أثناء محاولة تعديل الطلب يرجى التأكد من إتصالك بالإنترنت'));
    }
    store.dispatch(StopLoading());
  } else if (action is SetUpdateOrder) {
    store.dispatch(GetDeliveryMethods(addressId: int.parse(action.order.addressId)));
    store.dispatch(SelectPaymentMethod(
        selectedPaymentMethod:
            store.state.paymentState.paymentMethods.indexWhere((method) => method.id == action.order.paymentMethodId)));
    action.order.address.supportedCityName = store.state.supportedCityState.supportedCities
        .firstWhere((city) => city.id.toString() == action.order.address.supportedCityId)
        .name;
    store.dispatch(SaveAddresses(addresses: [action.order.address]));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String firebaseToken = prefs.getString('firebase_token');
    store.dispatch(SelectAddress(selectedAddress: 0, firebaseToken: firebaseToken));
    store.dispatch(SelectDeliveryMethod(
        selectedDeliveryMethod: store.state.deliveryMethodState.deliveryMethods
            .indexWhere((method) => method.id == action.order.deliveryMethodId)));
    store.dispatch(SetUpdateOrderId(orderId: action.order.id));
    if (action.order.id != -1) {
      store.dispatch(SaveOrderNote(note: action.order.userNotes));
      CartServices.moveOrderProductsToCart(order: action.order);
    }
  }
  next(action);
}
