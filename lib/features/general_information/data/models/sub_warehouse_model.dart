import '../../domain/entities/sub_warehouse_entity.dart';
import 'sub_warehouse_level_pivot_model.dart';

class SubWarehouseModel extends SubWarehouseEntity {
  SubWarehouseModel({id, name, directDiscount, levelPivot, discountPercentage, allowShopperAssign})
      : super(
          id: id,
          name: name,
          directDiscount: directDiscount,
          levelPivot: levelPivot,
          discountPercentage: discountPercentage,
          allowShopperAssign: allowShopperAssign,
        );
  factory SubWarehouseModel.fromJson(Map<String, dynamic> json) => SubWarehouseModel(
        id: json['id'],
        name: json['name'],
        levelPivot: json['pivot']['level_id'] == null ? null : SubWarehouseLevelPivotModel.fromJson(json['pivot']),
        discountPercentage: json['discount_percentage'] == null ? null : double.parse(json['discount_percentage']),
        directDiscount: json['direct_discount'],
        allowShopperAssign: json['allow_shopper_assign'].toString(),
      );
}
