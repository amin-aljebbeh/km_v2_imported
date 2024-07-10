import 'package:kammun_app/features/products/data/models/product_model.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/sub_warehouse_entity.dart';
import 'sub_warehouse_level_pivot_model.dart';

SubWarehouseResponse subWarehouseModelFromJson(String str) => SubWarehouseResponse.fromJson(json.decode(str));

class SubWarehouseResponse {
  bool success;
  SubWarehouseModel data;

  SubWarehouseResponse({this.success, this.data});

  factory SubWarehouseResponse.fromJson(Map<String, dynamic> json) =>
      SubWarehouseResponse(success: json['success'], data: SubWarehouseModel.fromJson(json['data']));

  Map<String, dynamic> toJson() => {'success': success};
}

class SubWarehouseModel extends SubWarehouseEntity {
  SubWarehouseModel(
      {id, name, directDiscount, levelPivot, discountPercentage, allowShopperAssign, products, requireAuthCodes})
      : super(
            id: id,
            name: name,
            directDiscount: directDiscount,
            levelPivot: levelPivot,
            discountPercentage: discountPercentage,
            allowShopperAssign: allowShopperAssign,
            products: products,
            requireAuthCodes: requireAuthCodes);

  factory SubWarehouseModel.fromJson(Map<String, dynamic> json) => SubWarehouseModel(
        id: json['id'],
        requireAuthCodes: json['require_auth_codes'],
        name: json['name'],
        levelPivot: json['pivot'] == null
            ? null
            : json['pivot']['level_id'] == null
                ? null
                : SubWarehouseLevelPivotModel.fromJson(json['pivot']),
        discountPercentage: json['discount_percentage'] == null ? null : double.parse(json['discount_percentage']),
        directDiscount: json['direct_discount'],
        products: json['products'] == null
            ? null
            : List<ProductModel>.from(json['products'].map((x) => ProductModel.fromJson(x))),
        allowShopperAssign: json['allow_shopper_assign'].toString(),
      );
}
