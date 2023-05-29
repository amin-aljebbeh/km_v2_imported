import '../../../../core/core_importer.dart';
import '../../data/models/changed_price_product_model.dart';
import '../../domain/entities/update_order_response_entity.dart';

UpdateOrderResponseModel updateOrderModelFromJson(String str) => UpdateOrderResponseModel.fromJson(json.decode(str));

class UpdateOrderResponseModel extends UpdateOrderResponseEntity {
  UpdateOrderResponseModel({success, reason, message, inactiveProducts, changedPriceProducts, data})
      : super(
          message: message,
          success: success,
          data: data,
          changedPriceProducts: changedPriceProducts,
          inactiveProducts: inactiveProducts,
          reason: reason,
        );

  factory UpdateOrderResponseModel.fromJson(Map<String, dynamic> json) => UpdateOrderResponseModel(
        success: json['success'],
        data: json['data'],
        reason: json['reason'].toString(),
        inactiveProducts: json['inactive_products'] != null
            ? List<String>.from(json['inactive_products'].map((x) => x.toString()))
            : [],
        changedPriceProducts: json['changed_price_products'] != null
            ? List<ChangedPriceProductModel>.from(
                json['changed_price_products'].map((x) => ChangedPriceProductModel.fromJson(x)))
            : [],
        message: json['message'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'reason': reason,
        'data': data,
        'inactive_products': List<dynamic>.from(inactiveProducts.map((x) => x)),
        'changed_price_products': List<dynamic>.from(changedPriceProducts.map((x) => x)),
      };
}
