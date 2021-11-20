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
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": data == null ? null : data.toJson(),
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
    this.subWarehouses,
    this.roles,
    this.permissions,
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
  List<Permission> permissions;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] == null ? null : json["id"],
        username: json["username"] == null ? null : json["username"],
        name: json["name"] == null ? null : json["name"],
        phone: json["phone"],
        apiToken: json["api_token"] == null ? null : json["api_token"],
        productOperationsPermission:
            json["product_operations_permission"] == null
                ? null
                : json["product_operations_permission"],
        addCategoryPermission: json["add_category_permission"] == null
            ? null
            : json["add_category_permission"],
        addSpecialOfferPermission: json["add_special_offer_permission"] == null
            ? null
            : json["add_special_offer_permission"],
        viewOrdersPermission: json["view_orders_permission"] == null
            ? null
            : json["view_orders_permission"],
        banUserPermission: json["ban_user_permission"] == null
            ? null
            : json["ban_user_permission"],
        viewReportPermission: json["view_report_permission"] == null
            ? null
            : json["view_report_permission"],
        addNotificationPermission: json["add_notification_permission"] == null
            ? null
            : json["add_notification_permission"],
        isSuperUser:
            json["is_super_user"] == null ? null : json["is_super_user"],
        warehouseId: json["warehouse_id"] == null ? null : json["warehouse_id"],
        firebaseToken:
            json["firebase_token"] == null ? null : json["firebase_token"],
        updateCategoryWarehousePermission:
            json["update_category_warehouse_permission"] == null
                ? null
                : json["update_category_warehouse_permission"],
        productWarehouseOperationsPermission:
            json["product_warehouse_operations_permission"] == null
                ? null
                : json["product_warehouse_operations_permission"],
        updateOrderPermission: json["update_order_permission"] == null
            ? null
            : json["update_order_permission"],
        subWarehouses: json["sub_warehouses"] == null
            ? null
            : List<SubWarehouse>.from(
                json["sub_warehouses"].map((x) => SubWarehouse.fromJson(x))),
        roles: json["roles"] == null
            ? null
            : List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
        permissions: json["permissions"] == null
            ? null
            : List<Permission>.from(
                json["permissions"].map((x) => Permission.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "username": username == null ? null : username,
        "name": name == null ? null : name,
        "phone": phone,
        "api_token": apiToken == null ? null : apiToken,
        "product_operations_permission": productOperationsPermission == null
            ? null
            : productOperationsPermission,
        "add_category_permission":
            addCategoryPermission == null ? null : addCategoryPermission,
        "add_special_offer_permission": addSpecialOfferPermission == null
            ? null
            : addSpecialOfferPermission,
        "view_orders_permission":
            viewOrdersPermission == null ? null : viewOrdersPermission,
        "ban_user_permission":
            banUserPermission == null ? null : banUserPermission,
        "view_report_permission":
            viewReportPermission == null ? null : viewReportPermission,
        "add_notification_permission": addNotificationPermission == null
            ? null
            : addNotificationPermission,
        "is_super_user": isSuperUser == null ? null : isSuperUser,
        "warehouse_id": warehouseId == null ? null : warehouseId,
        "firebase_token": firebaseToken == null ? null : firebaseToken,
        "update_category_warehouse_permission":
            updateCategoryWarehousePermission == null
                ? null
                : updateCategoryWarehousePermission,
        "product_warehouse_operations_permission":
            productWarehouseOperationsPermission == null
                ? null
                : productWarehouseOperationsPermission,
        "update_order_permission":
            updateOrderPermission == null ? null : updateOrderPermission,
        "sub_warehouses": subWarehouses == null
            ? null
            : List<dynamic>.from(subWarehouses.map((x) => x.toJson())),
        "roles": roles == null
            ? null
            : List<dynamic>.from(roles.map((x) => x.toJson())),
        "permissions": permissions == null
            ? null
            : List<dynamic>.from(permissions.map((x) => x.toJson())),
      };
}

class Permission {
  Permission({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  int id;
  String name;
  String slug;
  dynamic description;
  DateTime createdAt;
  dynamic updatedAt;
  PermissionPivot pivot;

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        slug: json["slug"] == null ? null : json["slug"],
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        pivot: json["pivot"] == null
            ? null
            : PermissionPivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "slug": slug == null ? null : slug,
        "description": description,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt,
        "pivot": pivot == null ? null : pivot.toJson(),
      };
}

class PermissionPivot {
  PermissionPivot({
    this.adminId,
    this.permissionId,
  });

  int adminId;
  int permissionId;

  factory PermissionPivot.fromJson(Map<String, dynamic> json) =>
      PermissionPivot(
        adminId: json["admin_id"] == null ? null : json["admin_id"],
        permissionId:
            json["permission_id"] == null ? null : json["permission_id"],
      );

  Map<String, dynamic> toJson() => {
        "admin_id": adminId == null ? null : adminId,
        "permission_id": permissionId == null ? null : permissionId,
      };
}

class Role {
  Role({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  int id;
  String name;
  String slug;
  dynamic description;
  DateTime createdAt;
  dynamic updatedAt;
  RolePivot pivot;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        slug: json["slug"] == null ? null : json["slug"],
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        pivot: json["pivot"] == null ? null : RolePivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "slug": slug == null ? null : slug,
        "description": description,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt,
        "pivot": pivot == null ? null : pivot.toJson(),
      };
}

class RolePivot {
  RolePivot({
    this.adminId,
    this.roleId,
  });

  int adminId;
  int roleId;

  factory RolePivot.fromJson(Map<String, dynamic> json) => RolePivot(
        adminId: json["admin_id"] == null ? null : json["admin_id"],
        roleId: json["role_id"] == null ? null : json["role_id"],
      );

  Map<String, dynamic> toJson() => {
        "admin_id": adminId == null ? null : adminId,
        "role_id": roleId == null ? null : roleId,
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
  SubWarehousePivot pivot;

  factory SubWarehouse.fromJson(Map<String, dynamic> json) => SubWarehouse(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        phone: json["phone"] == null ? null : json["phone"],
        businessDomain:
            json["business_domain"] == null ? null : json["business_domain"],
        accountingSystemId: json["accounting_system_id"] == null
            ? null
            : json["accounting_system_id"],
        warehouseId: json["warehouse_id"] == null ? null : json["warehouse_id"],
        pivot: json["pivot"] == null
            ? null
            : SubWarehousePivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "phone": phone == null ? null : phone,
        "business_domain": businessDomain == null ? null : businessDomain,
        "accounting_system_id":
            accountingSystemId == null ? null : accountingSystemId,
        "warehouse_id": warehouseId == null ? null : warehouseId,
        "pivot": pivot == null ? null : pivot.toJson(),
      };
}

class SubWarehousePivot {
  SubWarehousePivot({
    this.adminId,
    this.subWarehouseId,
  });

  int adminId;
  int subWarehouseId;

  factory SubWarehousePivot.fromJson(Map<String, dynamic> json) =>
      SubWarehousePivot(
        adminId: json["admin_id"] == null ? null : json["admin_id"],
        subWarehouseId:
            json["sub_warehouse_id"] == null ? null : json["sub_warehouse_id"],
      );

  Map<String, dynamic> toJson() => {
        "admin_id": adminId == null ? null : adminId,
        "sub_warehouse_id": subWarehouseId == null ? null : subWarehouseId,
      };
}
