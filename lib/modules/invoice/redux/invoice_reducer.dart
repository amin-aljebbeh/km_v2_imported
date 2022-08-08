import '../../../core/core_importer.dart';
import 'invoice_action.dart';
import 'invoice_state.dart';

Reducer<InvoiceState> invoiceReducer = combineReducers<InvoiceState>([
  TypedReducer<InvoiceState, SetInvoice>(setInvoice),
  TypedReducer<InvoiceState, UseWallet>(useWallet),
  TypedReducer<InvoiceState, DoNotUseWallet>(doNotUseWallet),
  TypedReducer<InvoiceState, UseCoupon>(useCoupon),
  TypedReducer<InvoiceState, DoNotUseCoupon>(doNotUseCoupon),
  TypedReducer<InvoiceState, SetDeliveryMethodId>(setDeliveryMethod),
  TypedReducer<InvoiceState, SetAddressId>(setAddressId),
  TypedReducer<InvoiceState, SetInvoiceView>(setInvoiceView),
  TypedReducer<InvoiceState, SetPaymentMethodId>(setPaymentMethodId),
  TypedReducer<InvoiceState, ShowCancelCoupon>(showCancelCoupon),
  TypedReducer<InvoiceState, HideCancelCoupon>(hideCancelCoupon),
]);

InvoiceState setInvoice(InvoiceState state, SetInvoice action) {
  return state.copyWith(invoice: action.invoiceModel);
}

InvoiceState useWallet(InvoiceState state, UseWallet action) {
  return state.copyWith(invoice: state.invoice.copyWith(useWallet: 1));
}

InvoiceState doNotUseWallet(InvoiceState state, DoNotUseWallet action) {
  return state.copyWith(invoice: state.invoice.copyWith(useWallet: 0));
}

InvoiceState useCoupon(InvoiceState state, UseCoupon action) {
  return state.copyWith(invoice: state.invoice.copyWith(couponCode: action.couponCode));
}

InvoiceState doNotUseCoupon(InvoiceState state, DoNotUseCoupon action) {
  return state.copyWith(invoice: state.invoice.copyWith(couponCode: ''));
}

InvoiceState setDeliveryMethod(InvoiceState state, SetDeliveryMethodId action) {
  return state.copyWith(invoice: state.invoice.copyWith(deliveryMethodId: action.deliveryMethodId));
}

InvoiceState setPaymentMethodId(InvoiceState state, SetPaymentMethodId action) {
  return state.copyWith(invoice: state.invoice.copyWith(paymentMethodId: action.paymentMethodId));
}

InvoiceState setAddressId(InvoiceState state, SetAddressId action) {
  return state.copyWith(invoice: state.invoice.copyWith(addressId: action.addressId));
}

InvoiceState setInvoiceView(InvoiceState state, SetInvoiceView action) {
  return state.copyWith(invoiceView: action.invoiceView);
}

InvoiceState showCancelCoupon(InvoiceState state, ShowCancelCoupon action) {
  return state.copyWith(showCancelCoupon: true);
}

InvoiceState hideCancelCoupon(InvoiceState state, HideCancelCoupon action) {
  return state.copyWith(showCancelCoupon: false);
}
