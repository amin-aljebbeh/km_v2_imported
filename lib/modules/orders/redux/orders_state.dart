import 'package:kammun_app/core/core_importer.dart';

@immutable
class OrdersState {
  final List<OrdersOriginalData> orders;
  final int updatedOrderId;
  final String updateNote;
  const OrdersState({this.updateNote, this.updatedOrderId, this.orders});

  factory OrdersState.initial() {
    return const OrdersState(orders: [], updatedOrderId: -1, updateNote: '');
  }

  OrdersState copyWith({List<OrdersOriginalData> orders, int updatedOrderId, String updateNote}) {
    return OrdersState(
      orders: orders ?? this.orders,
      updatedOrderId: updatedOrderId ?? this.updatedOrderId,
      updateNote: updateNote ?? this.updateNote,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrdersState &&
          runtimeType == other.runtimeType &&
          orders == other.orders &&
          updatedOrderId == other.updatedOrderId &&
          updateNote == other.updateNote;

  @override
  int get hashCode => super.hashCode;
}
