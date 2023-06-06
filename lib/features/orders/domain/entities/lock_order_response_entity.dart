import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

class LockOrderResponseEntity {
  bool success;
  String data;
  List<ProductEntity> products;

  LockOrderResponseEntity({this.success, this.data, this.products});
}
