class StatisticsSubWarehouseEntity {
  StatisticsSubWarehouseEntity({
    this.warehouseId,
    this.subWarehouseId,
    this.name,
    this.businessDomain,
    this.sumPurchasePrice,
    this.totalIncreaseValue,
    this.totalShoppingProfits,
  });

  int warehouseId;
  int subWarehouseId;
  String name;
  String businessDomain;
  String sumPurchasePrice;
  String totalIncreaseValue;
  String totalShoppingProfits;
}
