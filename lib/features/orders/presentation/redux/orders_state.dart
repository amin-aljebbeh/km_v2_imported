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
  final String toDateFilter;
  final String fromDateFilter;
  final String shopperFilter;
  final String shopperNameFilter;
  final String supportedCityFilter;
  final int totalOrdersNumber;

  const OrdersState({
    this.toDateFilter,
    this.totalOrdersNumber,
    this.fromDateFilter,
    this.shopperFilter,
    this.supportedCityFilter,
    this.statusFilter,
    this.warehouseFilter,
    this.assignFilter,
    this.ordersUSeCases,
    this.orders,
    this.shopperNameFilter,
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
      totalOrdersNumber: 0,
      ordersPage: 1,
      rateFilter: 0,
      limitedOrdersPage: 1,
      shopperFilter: '0',
      fromDateFilter: '',
      supportedCityFilter: '0',
      toDateFilter: '',
      shopperNameFilter: 'الجميع',
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
    String toDateFilter,
    String fromDateFilter,
    String shopperFilter,
    String supportedCityFilter,
    String shopperNameFilter,
    int totalOrdersNumber,
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
      supportedCityFilter: supportedCityFilter ?? this.supportedCityFilter,
      fromDateFilter: fromDateFilter ?? this.fromDateFilter,
      shopperFilter: shopperFilter ?? this.shopperFilter,
      toDateFilter: toDateFilter ?? this.toDateFilter,
      shopperNameFilter: shopperNameFilter ?? this.shopperNameFilter,
      totalOrdersNumber: totalOrdersNumber ?? this.totalOrdersNumber,
    );
  }

  @override
  List<Object> get props => [
        ordersUSeCases,
        orders,
        statusFilter,
        warehouseFilter,
        assignFilter,
        ordersPage,
        limitedOrdersPage,
        rateFilter,
        supportedCityFilter,
        fromDateFilter,
        shopperFilter,
        shopperNameFilter,
        toDateFilter,
        totalOrdersNumber
      ];
}
