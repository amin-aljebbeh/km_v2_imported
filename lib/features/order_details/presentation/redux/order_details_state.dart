import '../../../../core/core_importer.dart';
import '../../../orders/domain/entities/show_data_entity.dart';
import '../../domain/use_cases/order_details_use_cases.dart';

@immutable
class OrderDetailsState extends Equatable {
  final OrderDetailsUseCases orderDetailsUseCases;
  final ShowDataEntity invoice;

  const OrderDetailsState({this.orderDetailsUseCases, this.invoice});

  factory OrderDetailsState.initial() {
    return OrderDetailsState(orderDetailsUseCases: sl<OrderDetailsUseCases>());
  }

  OrderDetailsState copyWith({ShowDataEntity invoice}) {
    return OrderDetailsState(orderDetailsUseCases: orderDetailsUseCases, invoice: invoice ?? this.invoice);
  }

  @override
  List<Object> get props => [orderDetailsUseCases, invoice];
}
