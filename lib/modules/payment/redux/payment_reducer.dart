import '../../../core/core_importer.dart';
import 'payment_action.dart';
import 'payment_state.dart';

Reducer<PaymentState> paymentReducer = combineReducers<PaymentState>([
  TypedReducer<PaymentState, SelectPaymentMethod>(selectPaymentMethod),
  TypedReducer<PaymentState, PaymentMethodsFetchedSuccessfully>(paymentMethodsFetchedSuccessfully),
  TypedReducer<PaymentState, SaveOrder>(saveOrder),
  TypedReducer<PaymentState, SetRedirectBackUrl>(setRedirectBackUrl),
]);

PaymentState selectPaymentMethod(PaymentState state, SelectPaymentMethod action) {
  return state.copyWith(selectedPaymentMethod: action.selectedPaymentMethod);
}

PaymentState paymentMethodsFetchedSuccessfully(PaymentState state, PaymentMethodsFetchedSuccessfully action) {
  return state.copyWith(paymentMethods: action.paymentMethods);
}

PaymentState saveOrder(PaymentState state, SaveOrder action) {
  return state.copyWith(order: action.order);
}

PaymentState setRedirectBackUrl(PaymentState state, SetRedirectBackUrl action) {
  return state.copyWith(redirectBackUrl: action.redirectBackUrl);
}
