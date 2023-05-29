import '../../../../core/core_importer.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/use_cases/orders_use_cases.dart';

@immutable
class OrdersState extends Equatable {
  final OrdersUSeCases ordersUSeCases;
  final List<OrderEntity> viewOrders;
  final List<OrderEntity> searchOrders;

  const OrdersState({this.ordersUSeCases, this.viewOrders, this.searchOrders});

  factory OrdersState.initial() {
    return OrdersState(ordersUSeCases: sl<OrdersUSeCases>(), searchOrders: const [], viewOrders: const []);
  }

  OrdersState copyWith({List<OrderEntity> viewOrders, List<OrderEntity> searchOrders}) {
    return OrdersState(
      ordersUSeCases: ordersUSeCases,
      viewOrders: viewOrders ?? this.viewOrders,
      searchOrders: searchOrders ?? this.searchOrders,
    );
  }

  @override
  List<Object> get props => [ordersUSeCases, viewOrders, searchOrders];
}
