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
    this.phone,
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
    this.roles,
    this.shopper,
  });

  int id;
  String username;
  String name;
  dynamic phone;
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
  List<Role> roles;
  Shopper shopper;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        username: json["username"],
        name: json["name"],
        phone: json["phone"],
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
        roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
        shopper: Shopper.fromJson(json["shopper"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "name": name,
        "phone": phone,
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
        "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
        "shopper": shopper.toJson(),
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

class Role {
  Role({
    this.id,
    this.name,
    this.slug,
    this.pivot,
  });

  int id;
  String name;
  String slug;
  Pivot pivot;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        pivot: Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "pivot": pivot.toJson(),
      };
}

class Pivot {
  Pivot({
    this.adminId,
    this.roleId,
  });

  int adminId;
  int roleId;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        adminId: json["admin_id"],
        roleId: json["role_id"],
      );

  Map<String, dynamic> toJson() => {
        "admin_id": adminId,
        "role_id": roleId,
      };
}

class Shopper {
  Shopper({
    this.id,
    this.adminId,
    this.name,
    this.points,
    this.status,
    this.levelId,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int adminId;
  String name;
  int points;
  int status;
  int levelId;
  DateTime createdAt;
  DateTime updatedAt;

  factory Shopper.fromJson(Map<String, dynamic> json) => Shopper(
        id: json["id"],
        adminId: json["admin_id"],
        name: json["name"],
        points: json["points"],
        status: json["status"],
        levelId: json["level_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "admin_id": adminId,
        "name": name,
        "points": points,
        "status": status,
        "level_id": levelId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
