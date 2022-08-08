import 'package:kammun_app/core/common_models/start_order_model.dart';

import '../../order/models/submit_order_model.dart';

class GetOrders {}

class OrdersFetchedSuccessfully {
  final List<OrdersOriginalData> orders;

  OrdersFetchedSuccessfully({this.orders});
}

class CancelOrder {
  final String orderId;

  CancelOrder({this.orderId});
}

class UpdateOrder {
  final SubmitOrderModel submitOrderModel;

  UpdateOrder({this.submitOrderModel});
}

class LockOrder {
  final int orderId;

  LockOrder({this.orderId});
}

class RateOrder {
  final String orderId;
  final String userFeedback;
  final double rating;

  RateOrder({this.orderId, this.userFeedback, this.rating});
}

class SetUpdateOrder {
  final OrdersOriginalData order;

  SetUpdateOrder({this.order});
}

class SetNote {
  final String note;

  SetNote({this.note});
}

class SetUpdateOrderId {
  final int orderId;

  SetUpdateOrderId({this.orderId});
}
