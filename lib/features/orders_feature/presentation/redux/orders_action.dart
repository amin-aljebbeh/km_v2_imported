import 'package:kammun_app/core/core_importer.dart';

class ReAssignOrderAction {
  final int orderId;

  ReAssignOrderAction({this.orderId});
}

class UpdateOrderRatingAction {
  final int orderId;
  final int deliveryRating;
  final BuildContext context;

  UpdateOrderRatingAction({this.orderId, this.deliveryRating, this.context});
}
