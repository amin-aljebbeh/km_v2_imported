import 'changed_price_product_entity.dart';

class UpdateOrderResponseEntity {
  final bool success;
  final String reason;
  final String message;
  final List<String> inactiveProducts;
  final List<ChangedPriceProductEntity> changedPriceProducts;
  final String data;

  UpdateOrderResponseEntity(
      {this.success, this.reason, this.message, this.inactiveProducts, this.changedPriceProducts, this.data});
}
