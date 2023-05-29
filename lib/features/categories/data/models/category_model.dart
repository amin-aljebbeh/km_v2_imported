import 'package:kammun_app/features/categories/domain/entities/category_entity.dart';
import 'package:kammun_app/features/warehouses/data/models/warehouse_model.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({int id, String name, String imageFileName, String parentCategoryId, String isCompany, warehouses})
      : super(
          id: id,
          name: name,
          imageFileName: imageFileName,
          parentCategoryId: parentCategoryId,
          isCompany: isCompany,
          warehouses: warehouses,
        );

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'],
        name: json['name'],
        imageFileName: json['image_file_name'],
        parentCategoryId: json['parent_category_id'].toString(),
        isCompany: json['is_company'].toString(),
        warehouses: json['warehouses'] == null
            ? null
            : List<WarehouseModel>.from(json['warehouses'].map((x) => WarehouseModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image_file_name': imageFileName,
        'parent_category_id': parentCategoryId,
        'is_company': isCompany,
      };
}
