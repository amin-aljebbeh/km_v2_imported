class OrderProductPivotEntity {
  final String orderId;
  final String productId;
  final String purchasePrice;
  final String deletedAt;
  final String quantity;
  final int increaseValue;
  final int subWarehouseId;

  OrderProductPivotEntity({
    this.orderId,
    this.productId,
    this.purchasePrice,
    this.deletedAt,
    this.quantity,
    this.increaseValue,
    this.subWarehouseId,
  });
}
