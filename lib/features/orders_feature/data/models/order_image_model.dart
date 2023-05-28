import '../../domain/entities/order_image_entity.dart';

class OrderImageModel extends OrderImageEntity {
  OrderImageModel({id, orderId, imageFileName}) : super(id: id, orderId: orderId, imageFileName: imageFileName);

  factory OrderImageModel.fromJson(Map<String, dynamic> json) => OrderImageModel(
        id: json['id'],
        orderId: json['order_id'],
        imageFileName: json['image_file_name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_id': orderId,
        'image_file_name': imageFileName,
      };
}
