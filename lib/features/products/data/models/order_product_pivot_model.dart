import '../../domain/entities/order_product_pivot_entity.dart';

class OrderProductPivotModel extends OrderProductPivotEntity {
  OrderProductPivotModel({orderId, productId, purchasePrice, deletedAt, quantity, increaseValue, subWarehouseId})
      : super(
          orderId: orderId,
          productId: productId,
          purchasePrice: purchasePrice,
          deletedAt: deletedAt,
          quantity: quantity,
          increaseValue: increaseValue,
          subWarehouseId: subWarehouseId,
        );

  factory OrderProductPivotModel.fromJson(Map<String, dynamic> json) => OrderProductPivotModel(
        orderId: json['order_id'].toString(),
        productId: json['product_id'].toString(),
        purchasePrice: json['purchase_price'].toString(),
        quantity: json['quantity'].toString(),
        deletedAt: json['deleted_at'] ?? 'null',
        increaseValue: json['increase_value'] ?? 0,
        subWarehouseId: json['sub_warehouse_id'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'order_id': orderId,
        'product_id': productId,
        'purchase_price': purchasePrice,
        'quantity': quantity,
        'deleted_at': deletedAt
      };
}
