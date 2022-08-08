import '../../../core/core_importer.dart';
import '../models/payment_method_model.dart';

class GetPaymentMethods {}

class PaymentMethodsFetchedSuccessfully {
  final List<PaymentMethodModel> paymentMethods;

  PaymentMethodsFetchedSuccessfully({this.paymentMethods});
}

class SelectPaymentMethod {
  final int selectedPaymentMethod;

  SelectPaymentMethod({this.selectedPaymentMethod});
}

class CheckPayment {
  final String orderId;

  CheckPayment({this.orderId});
}

class SetRedirectBackUrl {
  final String redirectBackUrl;

  SetRedirectBackUrl({this.redirectBackUrl});
}

class PaymentFailed {}

class PaymentSucceeded {}

class WaitingForPaying {}

class RetryPayment {
  final OrdersOriginalData order;

  RetryPayment({this.order});
}

class SaveOrder {
  final OrdersOriginalData order;

  SaveOrder({this.order});
}
