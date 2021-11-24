import 'package:kammun_app/models/permission_model.dart';
import 'package:kammun_app/models/role_model.dart';
import 'package:kammun_app/models/shopper_model.dart';
import 'package:kammun_app/models/sub_warehouse_model.dart';

class AdminModel {
  AdminModel(
      {this.id,
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
      this.shopper});

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
  ShopperModel shopper;

  factory AdminModel.fromJson(Map<String, dynamic> json) => AdminModel(
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
        shopper: json["shopper"] == null
            ? null
            : ShopperModel.fromJson(json["shopper"]),
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
