import '../../../../core/core_importer.dart';
import '../../domain/entities/lock_order_response_entity.dart';

class LockOrderResponseModel extends LockOrderResponseEntity {
  LockOrderResponseModel({success, data, products}) : super(products: products, success: success, data: data);

  factory LockOrderResponseModel.fromJson(Map<String, dynamic> json) => LockOrderResponseModel(
        success: json['success'],
        data: json['data'],
        products: List<OrderProduct>.from(json['products'].map((x) => OrderProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data,
        'products': List<dynamic>.from(products.map((x) => x.toJson())),
      };
}
