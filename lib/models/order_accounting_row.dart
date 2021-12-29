class OrderAccountingRow {
  int subWarehouseId;
  String subWarehouseName;
  double customerPay;
  double payToSubWarehouse;

  OrderAccountingRow(
    this.subWarehouseId,
    this.subWarehouseName,
    this.customerPay,
    this.payToSubWarehouse,
  );
}
