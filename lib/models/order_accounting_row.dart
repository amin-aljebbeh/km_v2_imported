class OrderAccountingRow {
  int subWarehouseId;
  String subWarehouseName;
  double netPrice;
  double payToSubWarehouse;
  double increaseValuesSum;

  OrderAccountingRow({
    this.subWarehouseId,
    this.subWarehouseName,
    this.netPrice,
    this.payToSubWarehouse,
    this.increaseValuesSum,
  });
}
