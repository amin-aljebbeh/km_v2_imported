class SubWarehouseLevelPivot {
  SubWarehouseLevelPivot({
    this.levelId,
    this.subWarehouseId,
    this.shoppingProfitPercentage,
    this.valueAddedPercentage,
    this.minProfit,
    this.maxProfit,
  });

  int levelId;
  int subWarehouseId;
  double shoppingProfitPercentage;
  double valueAddedPercentage;
  int minProfit;
  int maxProfit;

  factory SubWarehouseLevelPivot.fromJson(Map<String, dynamic> json) => SubWarehouseLevelPivot(
        levelId: json["level_id"] == null ? null : json["admin_id"],
        subWarehouseId: json["sub_warehouse_id"],
        shoppingProfitPercentage:
            json["shopping_profit_percentage"] == null ? null : double.parse(json["shopping_profit_percentage"]),
        valueAddedPercentage:
            json["value_added_percentage"] == null ? null : double.parse(json["value_added_percentage"]),
        minProfit: json["min_profit"],
        maxProfit: json["max_profit"],
      );

  Map<String, dynamic> toJson() => {
        "level_id": levelId,
        "sub_warehouse_id": subWarehouseId,
        "shopping_profit_percentage": shoppingProfitPercentage,
        "value_added_percentage": valueAddedPercentage,
      };
}
