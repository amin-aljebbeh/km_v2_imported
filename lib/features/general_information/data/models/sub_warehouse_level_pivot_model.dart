import '../../domain/entities/sub_warehouse_level_pivot_entity.dart';

class SubWarehouseLevelPivotModel extends SubWarehouseLevelPivotEntity {
  SubWarehouseLevelPivotModel(
      {levelId, subWarehouseId, shoppingProfitPercentage, valueAddedPercentage, minProfit, maxProfit})
      : super(
          levelId: levelId,
          subWarehouseId: subWarehouseId,
          shoppingProfitPercentage: shoppingProfitPercentage,
          valueAddedPercentage: valueAddedPercentage,
          minProfit: minProfit,
          maxProfit: maxProfit,
        );

  factory SubWarehouseLevelPivotModel.fromJson(Map<String, dynamic> json) => SubWarehouseLevelPivotModel(
        levelId: json['level_id'] == null ? null : json['admin_id'],
        subWarehouseId: json['sub_warehouse_id'],
        shoppingProfitPercentage:
            json['shopping_profit_percentage'] == null ? null : double.parse(json['shopping_profit_percentage']),
        valueAddedPercentage:
            json['value_added_percentage'] == null ? null : double.parse(json['value_added_percentage']),
        minProfit: json['min_profit'],
        maxProfit: json['max_profit'],
      );
}
