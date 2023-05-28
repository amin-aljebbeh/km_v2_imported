import 'package:kammun_app/features/products/domain/entities/product_image_entity.dart';

class ProductImageModel extends ProductImageEntity {
  ProductImageModel({int id, String productId, String imageFileName})
      : super(id: id, productId: productId, imageFileName: imageFileName);

  factory ProductImageModel.fromJson(Map<String, dynamic> json) => ProductImageModel(
      id: json['id'], productId: json['product_id'].toString(), imageFileName: json['image_file_name']);

  Map<String, dynamic> toJson() => {'id': id, 'product_id': productId, 'image_file_name': imageFileName};
}
