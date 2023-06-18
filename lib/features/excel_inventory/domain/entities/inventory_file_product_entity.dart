import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

class InventoryFileProductEntity {
  InventoryFileProductEntity({this.nonIntroducedProducts, this.activatedList, this.toActiveList, this.toDeActiveList});
  List<ProductEntity> toActiveList;
  List<ProductEntity> activatedList;
  List<ProductEntity> toDeActiveList;
  List<ProductEntity> nonIntroducedProducts;
}
