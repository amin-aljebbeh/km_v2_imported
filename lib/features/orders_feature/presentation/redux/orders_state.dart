import '../../../../core/core_importer.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/use_cases/orders_use_cases.dart';

@immutable
class OrdersState extends Equatable {
  final OrdersUSeCases ordersUSeCases;
  final List<OrderEntity> orders;
  final int statusFilter;
  final int warehouseFilter;
  final int assignFilter;
  final int ordersPage;
  final int limitedOrdersPage;
  final int rateFilter;

  const OrdersState({
    this.statusFilter,
    this.warehouseFilter,
    this.assignFilter,
    this.ordersUSeCases,
    this.orders,
    this.ordersPage,
    this.limitedOrdersPage,
    this.rateFilter,
  });

  factory OrdersState.initial() {
    return OrdersState(
      ordersUSeCases: sl<OrdersUSeCases>(),
      orders: const [],
      statusFilter: 0,
      assignFilter: 0,
      warehouseFilter: 0,
      ordersPage: 1,
      rateFilter: 0,
      limitedOrdersPage: 1,
    );
  }

  OrdersState copyWith({
    List<OrderEntity> orders,
    int statusFilter,
    int warehouseFilter,
    int assignFilter,
    int ordersPage,
    int limitedOrdersPage,
    int rateFilter,
  }) {
    return OrdersState(
      ordersUSeCases: ordersUSeCases,
      orders: orders ?? this.orders,
      statusFilter: statusFilter ?? this.statusFilter,
      assignFilter: assignFilter ?? this.assignFilter,
      warehouseFilter: warehouseFilter ?? this.warehouseFilter,
      ordersPage: ordersPage ?? this.ordersPage,
      limitedOrdersPage: limitedOrdersPage ?? this.limitedOrdersPage,
      rateFilter: rateFilter ?? this.rateFilter,
    );
  }

  @override
  List<Object> get props =>
      [ordersUSeCases, orders, statusFilter, warehouseFilter, assignFilter, ordersPage, limitedOrdersPage, rateFilter];
}
