import '../../../core/core_importer.dart';
import '../models/submit_order_model.dart';

@immutable
class OrderState {
  final SubmitOrderModel submitOrderModel;
  final OrderResponse orderResponse;
  final List<ProductData> notActiveProducts;
  final List<ProductData> priceProducts;

  const OrderState({this.submitOrderModel, this.orderResponse, this.notActiveProducts, this.priceProducts});

  factory OrderState.initial() {
    return OrderState(
      notActiveProducts: const [],
      priceProducts: const [],
      orderResponse: OrderResponse(changedPriceProducts: [], inactiveProducts: []),
      submitOrderModel: SubmitOrderModel(),
    );
  }

  OrderState copyWith(
      {OrderResponse orderResponse,
      List<ProductData> notActiveProducts,
      List<ProductData> priceProducts,
      SubmitOrderModel submitOrderModel}) {
    return OrderState(
      orderResponse: orderResponse ?? this.orderResponse,
      priceProducts: priceProducts ?? this.priceProducts,
      notActiveProducts: notActiveProducts ?? this.notActiveProducts,
      submitOrderModel: submitOrderModel ?? this.submitOrderModel,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderState &&
          runtimeType == other.runtimeType &&
          priceProducts == other.priceProducts &&
          notActiveProducts == other.notActiveProducts &&
          orderResponse == other.orderResponse &&
          submitOrderModel == other.submitOrderModel;

  @override
  int get hashCode => super.hashCode;
}
