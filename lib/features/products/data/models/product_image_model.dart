import 'package:kammun_app/features/products/domain/entities/product_image_entity.dart';

class ProductImageModel extends ProductImageEntity {
  ProductImageModel({int id, String imageFileName}) : super(id: id, imageFileName: imageFileName);

  factory ProductImageModel.fromJson(Map<String, dynamic> json) =>
      ProductImageModel(id: json['id'], imageFileName: json['image_file_name']);

  Map<String, dynamic> toJson() => {'id': id, 'image_file_name': imageFileName};
}
