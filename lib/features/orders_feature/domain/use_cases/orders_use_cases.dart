import 'package:kammun_app/features/orders_feature/domain/use_cases/re_assign_order_use_case.dart';

import '../../../../core/core_importer.dart';

class OrdersUSeCases {
  final ReAssignOrderUseCase reAssignOrderUseCase;

  OrdersUSeCases({@required this.reAssignOrderUseCase})
      : assert(reAssignOrderUseCase != null, 'All use cases should be initialized.');
}
