class SubWarehouseAdminPivot {
  SubWarehouseAdminPivot({
    this.adminId,
    this.subWarehouseId,
  });

  int adminId;
  int subWarehouseId;

  factory SubWarehouseAdminPivot.fromJson(Map<String, dynamic> json) => SubWarehouseAdminPivot(
        adminId: json["admin_id"],
        subWarehouseId: json["sub_warehouse_id"],
      );

  Map<String, dynamic> toJson() => {
        "admin_id": adminId,
        "sub_warehouse_id": subWarehouseId,
      };
}
