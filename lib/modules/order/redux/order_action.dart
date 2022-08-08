import '../../../core/core_importer.dart';
import '../models/submit_order_model.dart';

class SubmitOrder {
  final SubmitOrderModel submitOrderModel;

  SubmitOrder({this.submitOrderModel});
}

class OrderSubmittedSuccessfully {
  final OrderResponse orderResponse;

  OrderSubmittedSuccessfully({this.orderResponse});
}

class ErrorCreatingOrder {
  List<String> inactiveProducts;
  List<ChangedPriceProduct> changedPriceProducts;
  final List<ProductData> cart;

  ErrorCreatingOrder({this.cart, this.inactiveProducts, this.changedPriceProducts});
}

class UpdateOrderPrices {}

class SetOrderProblemProducts {
  final List<ProductData> notActiveProducts;
  final List<ProductData> priceProducts;

  SetOrderProblemProducts({this.notActiveProducts, this.priceProducts});
}

class SaveOrderNote {
  final String note;

  SaveOrderNote({this.note});
}

class SaveCoupon {
  final String coupon;

  SaveCoupon({this.coupon});
}

class InitializeSubmitOrderModel {
  final SubmitOrderModel order;

  InitializeSubmitOrderModel({this.order});
}

class SetOrderInvoice {
  final InvoiceModel invoiceModel;

  SetOrderInvoice({this.invoiceModel});
}

class GetOrder {
  final bool forCart;
  final bool goToCart;
  final int orderId;

  GetOrder({this.goToCart = false, this.forCart, this.orderId});
}
