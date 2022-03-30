import 'package:kammun_app/utils/tools.dart';

class SubWarehouseLevelPivot {
  SubWarehouseLevelPivot({
    this.levelId,
    this.subWarehouseId,
    this.shoppingProfitPercentage,
    this.valueAddedPercentage,
  });

  int levelId;
  int subWarehouseId;
  double shoppingProfitPercentage;
  double valueAddedPercentage;

  factory SubWarehouseLevelPivot.fromJson(Map<String, dynamic> json) {
    Tools.logToConsole('pivot 1');
    SubWarehouseLevelPivot(
      levelId: json["level_id"] == null ? null : json["admin_id"],
      subWarehouseId: json["sub_warehouse_id"],
      shoppingProfitPercentage:
          json["shopping_profit_percentage"] == null ? null : double.parse(json["shopping_profit_percentage"]),
      valueAddedPercentage:
          json["value_added_percentage"] == null ? null : double.parse(json["value_added_percentage"]),
    );
    Tools.logToConsole('pivot 2');
    return SubWarehouseLevelPivot(
      levelId: json["level_id"] == null ? null : json["admin_id"],
      subWarehouseId: json["sub_warehouse_id"],
      shoppingProfitPercentage:
          json["shopping_profit_percentage"] == null ? null : double.parse(json["shopping_profit_percentage"]),
      valueAddedPercentage:
          json["value_added_percentage"] == null ? null : double.parse(json["value_added_percentage"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "level_id": levelId,
        "sub_warehouse_id": subWarehouseId,
        "shopping_profit_percentage": shoppingProfitPercentage,
        "value_added_percentage": valueAddedPercentage,
      };
}
