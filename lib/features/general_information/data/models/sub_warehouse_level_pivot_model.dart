import '../../domain/entities/sub_warehouse_level_pivot_entity.dart';

class SubWarehouseLevelPivotModel extends SubWarehouseLevelPivotEntity {
  SubWarehouseLevelPivotModel({shoppingProfitPercentage, valueAddedPercentage, minProfit, maxProfit})
      : super(
          shoppingProfitPercentage: shoppingProfitPercentage,
          valueAddedPercentage: valueAddedPercentage,
          minProfit: minProfit,
          maxProfit: maxProfit,
        );

  factory SubWarehouseLevelPivotModel.fromJson(Map<String, dynamic> json) => SubWarehouseLevelPivotModel(
        shoppingProfitPercentage:
            json['shopping_profit_percentage'] == null ? null : double.parse(json['shopping_profit_percentage']),
        valueAddedPercentage:
            json['value_added_percentage'] == null ? null : double.parse(json['value_added_percentage']),
        minProfit: json['min_profit'],
        maxProfit: json['max_profit'],
      );
}
