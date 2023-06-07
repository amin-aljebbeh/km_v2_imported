import 'package:kammun_app/features/products/domain/entities/category_products_pagination_entity.dart';

class CategoryProductsEntity {
  final bool success;
  final CategoryProductsPaginationEntity page;

  CategoryProductsEntity({this.success, this.page});
}
