import 'package:kammun_app/utils/tools.dart';

class SubWarehouseAdminPivot {
  SubWarehouseAdminPivot({
    this.adminId,
    this.subWarehouseId,
  });

  int adminId;
  int subWarehouseId;

  factory SubWarehouseAdminPivot.fromJson(Map<String, dynamic> json) {
    Tools.logToConsole('sub_warehouse 1');
    SubWarehouseAdminPivot(
      adminId: json["admin_id"],
      subWarehouseId: json["sub_warehouse_id"],
    );
    Tools.logToConsole('sub_warehouse 2');
    return SubWarehouseAdminPivot(
      adminId: json["admin_id"],
      subWarehouseId: json["sub_warehouse_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "admin_id": adminId,
        "sub_warehouse_id": subWarehouseId,
      };
}
