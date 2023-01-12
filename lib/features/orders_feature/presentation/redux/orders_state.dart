import '../../../../core/core_importer.dart';
import '../../domain/use_cases/orders_use_cases.dart';

@immutable
class OrdersState extends Equatable {
  final OrdersUSeCases ordersUSeCases;
  const OrdersState({this.ordersUSeCases});

  factory OrdersState.initial() {
    return OrdersState(ordersUSeCases: sl<OrdersUSeCases>());
  }

  OrdersState copyWith() {
    return OrdersState(ordersUSeCases: ordersUSeCases);
  }

  @override
  List<Object> get props => [];
}
