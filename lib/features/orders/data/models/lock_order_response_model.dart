import 'package:kammun_app/features/products/data/models/product_model.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/lock_order_response_entity.dart';

LockOrderResponseModel lockOrderModelFromJson(String str) => LockOrderResponseModel.fromJson(json.decode(str));

class LockOrderResponseModel extends LockOrderResponseEntity {
  LockOrderResponseModel({success, data, products}) : super(products: products, success: success, data: data);

  factory LockOrderResponseModel.fromJson(Map<String, dynamic> json) => LockOrderResponseModel(
        success: json['success'],
        data: json['data'],
        products: List<ProductModel>.from(json['products'].map((x) => ProductModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data,
      };
}
