import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

class PricesChangesEntity {
  PricesChangesEntity({this.success, this.count, this.products});

  bool success;
  int count;
  List<ProductEntity> products;
}
