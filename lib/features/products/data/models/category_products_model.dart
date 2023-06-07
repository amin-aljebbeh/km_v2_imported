import '../../../../core/core_importer.dart';
import '../../domain/entities/category_products_entity.dart';
import 'category_products_pagination_model.dart';

CategoryProductsModel categoryProductsFromJson(String str) => CategoryProductsModel.fromJson(json.decode(str));

class CategoryProductsModel extends CategoryProductsEntity {
  CategoryProductsModel({success, page}) : super(success: success, page: page);

  factory CategoryProductsModel.fromJson(Map<String, dynamic> json) =>
      CategoryProductsModel(success: json['success'], page: CategoryProductsPaginationModel.fromJson(json['data']));
}
