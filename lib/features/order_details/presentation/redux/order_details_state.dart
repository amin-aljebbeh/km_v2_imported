import '../../../../core/core_importer.dart';
import '../../../orders/domain/entities/show_data_entity.dart';
import '../../domain/use_cases/order_details_use_cases.dart';

@immutable
class OrderDetailsState extends Equatable {
  final OrderDetailsUseCases orderDetailsUseCases;
  final ShowDataEntity invoice;
  final Map<int, List<int>> authenticatedSubWarehouses; // The int is the order id

  const OrderDetailsState({this.authenticatedSubWarehouses, this.orderDetailsUseCases, this.invoice});

  factory OrderDetailsState.initial() {
    return OrderDetailsState(orderDetailsUseCases: sl<OrderDetailsUseCases>(), authenticatedSubWarehouses: const {});
  }

  OrderDetailsState copyWith({ShowDataEntity invoice, Map<int, List<int>> authenticatedSubWarehouses}) {
    return OrderDetailsState(
        orderDetailsUseCases: orderDetailsUseCases,
        invoice: invoice ?? this.invoice,
        authenticatedSubWarehouses: authenticatedSubWarehouses ?? this.authenticatedSubWarehouses);
  }

  @override
  List<Object> get props => [orderDetailsUseCases, invoice, authenticatedSubWarehouses];
}
