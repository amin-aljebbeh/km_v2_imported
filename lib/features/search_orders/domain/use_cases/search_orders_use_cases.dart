import '../../../../core/core_importer.dart';
import '../../../search_orders/domain/use_cases/get_order_use_case.dart';
import '../../../search_orders/domain/use_cases/get_orders_by_user_number_use_case.dart';

class SearchOrdersUSeCases {
  final GetOrderUseCase getOrderUseCase;
  final GetOrdersByUserNumberUseCase getOrdersByUserNumberUseCase;

  SearchOrdersUSeCases({@required this.getOrderUseCase, @required this.getOrdersByUserNumberUseCase})
      : assert(getOrderUseCase != null && getOrdersByUserNumberUseCase != null, 'All use cases should be initialized.');
}
