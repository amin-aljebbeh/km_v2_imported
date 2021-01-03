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
    this.addProductPermission,
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
    this.updateProductWarehousePermission,
  });

  int id;
  String username;
  String name;
  String apiToken;
  String addProductPermission;
  String addCategoryPermission;
  String addSpecialOfferPermission;
  String viewOrdersPermission;
  String banUserPermission;
  String viewReportPermission;
  String addNotificationPermission;
  String isSuperUser;
  String warehouseId;
  dynamic firebaseToken;
  String updateCategoryWarehousePermission;
  String updateProductWarehousePermission;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        username: json["username"],
        name: json["name"],
        apiToken: json["api_token"],
        addProductPermission: json["add_product_permission"],
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
        updateProductWarehousePermission:
            json["update_product_warehouse_permission"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "name": name,
        "api_token": apiToken,
        "add_product_permission": addProductPermission,
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
        "update_product_warehouse_permission": updateProductWarehousePermission,
      };
}
