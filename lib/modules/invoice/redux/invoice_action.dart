import '../models/check_invoice_model.dart';
import '../models/invoice_view_widget_model.dart';

class UseEPay {}

class DoNotUseEPay {}

class SetTotal {
  final int total;

  SetTotal({this.total});
}

class CheckInvoice {
  final bool goToInvoice;
  final bool showCancel;
  final CheckInvoiceModel invoice;

  CheckInvoice({this.showCancel = false, this.invoice, this.goToInvoice = false});
}

class CheckInvoiceOnUpdate {
  final CheckInvoiceModel invoice;
  final String orderId;

  CheckInvoiceOnUpdate({this.orderId, this.invoice});
}

class SetInvoice {
  final CheckInvoiceModel invoiceModel;

  SetInvoice({this.invoiceModel});
}

class SetDeliveryMethodId {
  final int deliveryMethodId;

  SetDeliveryMethodId({this.deliveryMethodId});
}

class SetAddressId {
  final int addressId;

  SetAddressId({this.addressId});
}

class SetPaymentMethodId {
  final int paymentMethodId;

  SetPaymentMethodId({this.paymentMethodId});
}

class UseWallet {}

class DoNotUseWallet {}

class UseCoupon {
  final String couponCode;

  UseCoupon({this.couponCode});
}

class DoNotUseCoupon {}

class SetInvoiceView {
  final InvoiceViewWidgetModel invoiceView;

  SetInvoiceView({this.invoiceView});
}

class CancelCoupon {
  final String orderId;

  CancelCoupon({this.orderId});
}

class ShowCancelCoupon {}

class HideCancelCoupon {}
