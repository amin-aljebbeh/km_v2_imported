import '../../../core/core_importer.dart';
import '../models/payment_method_model.dart';

@immutable
class PaymentState {
  final int selectedPaymentMethod;
  final List<PaymentMethodModel> paymentMethods;
  final OrdersOriginalData order;
  final String redirectBackUrl;

  const PaymentState({this.redirectBackUrl, this.order, this.paymentMethods, this.selectedPaymentMethod});

  factory PaymentState.initial() {
    return PaymentState(
        selectedPaymentMethod: 0, paymentMethods: const [], order: OrdersOriginalData(), redirectBackUrl: '');
  }

  PaymentState copyWith(
      {int selectedPaymentMethod,
      List<PaymentMethodModel> paymentMethods,
      OrdersOriginalData order,
      String redirectBackUrl}) {
    return PaymentState(
        selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
        paymentMethods: paymentMethods ?? this.paymentMethods,
        order: order ?? this.order,
        redirectBackUrl: redirectBackUrl ?? this.redirectBackUrl);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentState &&
          runtimeType == other.runtimeType &&
          selectedPaymentMethod == other.selectedPaymentMethod &&
          paymentMethods == other.paymentMethods &&
          redirectBackUrl == other.redirectBackUrl &&
          order == other.order;

  @override
  int get hashCode => super.hashCode;
}
