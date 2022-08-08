import '../../../core/core_importer.dart';
import 'order_action.dart';
import 'order_state.dart';

Reducer<OrderState> orderReducer = combineReducers<OrderState>([
  TypedReducer<OrderState, OrderSubmittedSuccessfully>(orderSubmittedSuccessfully),
  TypedReducer<OrderState, SetOrderProblemProducts>(setOrderProblemProducts),
  TypedReducer<OrderState, SaveOrderNote>(saveNote),
  TypedReducer<OrderState, InitializeSubmitOrderModel>(initializeSubmitOrderModel),
  TypedReducer<OrderState, SetOrderInvoice>(setOrderInvoice),
  TypedReducer<OrderState, SaveCoupon>(saveCoupon),
]);

OrderState orderSubmittedSuccessfully(OrderState state, OrderSubmittedSuccessfully action) {
  return state.copyWith(orderResponse: action.orderResponse);
}

OrderState setOrderProblemProducts(OrderState state, SetOrderProblemProducts action) {
  return state.copyWith(priceProducts: action.priceProducts, notActiveProducts: action.notActiveProducts);
}

OrderState saveNote(OrderState state, SaveOrderNote action) {
  return state.copyWith(submitOrderModel: state.submitOrderModel.copyWith(userNote: action.note));
}

OrderState initializeSubmitOrderModel(OrderState state, InitializeSubmitOrderModel action) {
  return state.copyWith(submitOrderModel: state.submitOrderModel);
}

OrderState setOrderInvoice(OrderState state, SetOrderInvoice action) {
  return state.copyWith(submitOrderModel: state.submitOrderModel.copyWith(invoice: action.invoiceModel));
}

OrderState saveCoupon(OrderState state, SaveCoupon action) {
  return state.copyWith(submitOrderModel: state.submitOrderModel.copyWith(couponCode: action.coupon));
}
