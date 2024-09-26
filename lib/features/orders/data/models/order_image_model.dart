import '../../domain/entities/order_image_entity.dart';

class OrderImageModel extends OrderImageEntity {
  OrderImageModel({id, imageFileName}) : super(id: id, imageFileName: imageFileName);

  factory OrderImageModel.fromJson(Map<String, dynamic> json) =>
      OrderImageModel(id: json['id'], imageFileName: json['image_file_name']);

  Map<String, dynamic> toJson() => {'id': id, 'image_file_name': imageFileName};
}
