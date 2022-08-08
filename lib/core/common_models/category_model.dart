import '../../modules/startup/models/warehouse_model.dart';

class CategoryModel {
  CategoryModel({
    this.id,
    this.name,
    this.imageFileName,
    this.parentCategoryId,
    this.isCompany,
    this.warehouses,
  });

  int id;
  String name;
  String imageFileName;
  int parentCategoryId;
  String isCompany;
  List<Warehouse> warehouses;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'],
        name: json['name'],
        imageFileName: json['image_file_name'],
        parentCategoryId: json['parent_category_id'] ?? -1,
        isCompany: json['is_company'].toString(),
        warehouses: List<Warehouse>.from(json['warehouses'].map((x) => Warehouse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image_file_name': imageFileName,
        'parent_category_id': parentCategoryId,
        'is_company': isCompany,
        'warehouses': List<dynamic>.from(warehouses.map((x) => x.toJson())),
      };
}
