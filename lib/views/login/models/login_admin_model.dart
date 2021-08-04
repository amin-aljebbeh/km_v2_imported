// To parse this JSON data, do
//
//     final adminLoginResponse = adminLoginResponseFromJson(jsonString);

import 'dart:convert';

AdminLoginResponse adminLoginResponseFromJson(String str) =>
    AdminLoginResponse.fromJson(json.decode(str));

String adminLoginResponseToJson(AdminLoginResponse data) =>
    json.encode(data.toJson());

class AdminLoginResponse {
  AdminLoginResponse({
    this.success,
    this.data,
  });

  bool success;
  Data data;

  factory AdminLoginResponse.fromJson(Map<String, dynamic> json) =>
      AdminLoginResponse(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.username,
    this.name,
    this.apiToken,
    this.productOperationsPermission,
    this.addCategoryPermission,
    this.addSpecialOfferPermission,
    this.viewOrdersPermission,
    this.banUserPermission,
    this.viewReportPermission,
    this.addNotificationPermission,
    this.isSuperUser,
    this.warehouseId,
    this.firebaseToken,
    this.updateCategoryWarehousePermission,
    this.productWarehouseOperationsPermission,
    this.updateOrderPermission,
    this.subWarehouses,
  });

  int id;
  String username;
  String name;
  String apiToken;
  int productOperationsPermission;
  int addCategoryPermission;
  int addSpecialOfferPermission;
  int viewOrdersPermission;
  int banUserPermission;
  int viewReportPermission;
  int addNotificationPermission;
  int isSuperUser;
  int warehouseId;
  String firebaseToken;
  int updateCategoryWarehousePermission;
  int productWarehouseOperationsPermission;
  int updateOrderPermission;
  List<SubWarehouse> subWarehouses;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        username: json["username"],
        name: json["name"],
        apiToken: json["api_token"],
        productOperationsPermission: json["product_operations_permission"],
        addCategoryPermission: json["add_category_permission"],
        addSpecialOfferPermission: json["add_special_offer_permission"],
        viewOrdersPermission: json["view_orders_permission"],
        banUserPermission: json["ban_user_permission"],
        viewReportPermission: json["view_report_permission"],
        addNotificationPermission: json["add_notification_permission"],
        isSuperUser: json["is_super_user"],
        warehouseId: json["warehouse_id"],
        firebaseToken: json["firebase_token"],
        updateCategoryWarehousePermission:
            json["update_category_warehouse_permission"],
        productWarehouseOperationsPermission:
            json["product_warehouse_operations_permission"],
        updateOrderPermission: json["update_order_permission"],
        subWarehouses: json["sub_warehouses"] == null
            ? null
            : List<SubWarehouse>.from(
                json["sub_warehouses"].map((x) => SubWarehouse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "name": name,
        "api_token": apiToken,
        "product_operations_permission": productOperationsPermission,
        "add_category_permission": addCategoryPermission,
        "add_special_offer_permission": addSpecialOfferPermission,
        "view_orders_permission": viewOrdersPermission,
        "ban_user_permission": banUserPermission,
        "view_report_permission": viewReportPermission,
        "add_notification_permission": addNotificationPermission,
        "is_super_user": isSuperUser,
        "warehouse_id": warehouseId,
        "firebase_token": firebaseToken,
        "update_category_warehouse_permission":
            updateCategoryWarehousePermission,
        "product_warehouse_operations_permission":
            productWarehouseOperationsPermission,
        "update_order_permission": updateOrderPermission,
        "sub_warehouses":
            List<dynamic>.from(subWarehouses.map((x) => x.toJson())),
      };
}

class SubWarehouse {
  SubWarehouse({
    this.id,
    this.name,
    this.description,
    this.phone,
    this.businessDomain,
    this.accountingSystemId,
    this.warehouseId,
    this.pivot,
  });

  int id;
  String name;
  String description;
  String phone;
  String businessDomain;
  int accountingSystemId;
  int warehouseId;
  Pivot pivot;

  factory SubWarehouse.fromJson(Map<String, dynamic> json) => SubWarehouse(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        phone: json["phone"],
        businessDomain: json["business_domain"],
        accountingSystemId: json["accounting_system_id"],
        warehouseId: json["warehouse_id"],
        pivot: Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "phone": phone,
        "business_domain": businessDomain,
        "accounting_system_id": accountingSystemId,
        "warehouse_id": warehouseId,
        "pivot": pivot.toJson(),
      };
}

class Pivot {
  Pivot({
    this.adminId,
    this.subWarehouseId,
  });

  int adminId;
  int subWarehouseId;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        adminId: json["admin_id"] == null ? null : json["admin_id"],
        subWarehouseId:
            json["sub_warehouse_id"] == null ? null : json["sub_warehouse_id"],
      );

  Map<String, dynamic> toJson() => {
        "admin_id": adminId == null ? null : adminId,
        "sub_warehouse_id": subWarehouseId == null ? null : subWarehouseId,
      };
}
