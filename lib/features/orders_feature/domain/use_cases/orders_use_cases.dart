import 'package:kammun_app/features/orders_feature/domain/use_cases/re_assign_order_use_case.dart';

import '../../../../core/core_importer.dart';
import 'update_order_rating_use_case.dart';

class OrdersUSeCases {
  final ReAssignOrderUseCase reAssignOrderUseCase;
  final UpdateOrderRatingUseCase updateOrderRatingUseCase;

  OrdersUSeCases({@required this.reAssignOrderUseCase, @required this.updateOrderRatingUseCase})
      : assert(
            reAssignOrderUseCase != null && updateOrderRatingUseCase != null, 'All use cases should be initialized.');
}
