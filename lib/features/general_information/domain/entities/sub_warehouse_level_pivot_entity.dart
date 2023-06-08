class SubWarehouseLevelPivotEntity {
  final int levelId;
  final int subWarehouseId;
  final double shoppingProfitPercentage;
  final double valueAddedPercentage;
  final int minProfit;
  final int maxProfit;

  SubWarehouseLevelPivotEntity({
    this.levelId,
    this.subWarehouseId,
    this.shoppingProfitPercentage,
    this.valueAddedPercentage,
    this.minProfit,
    this.maxProfit,
  });
}
