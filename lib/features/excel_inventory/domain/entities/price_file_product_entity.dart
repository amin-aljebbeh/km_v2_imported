import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

class PriceFileProductEntity {
  List<ProductEntity> productsPriceChange;
  List<ProductEntity> nonIntroducedProducts;

  PriceFileProductEntity({this.productsPriceChange, this.nonIntroducedProducts});
}
