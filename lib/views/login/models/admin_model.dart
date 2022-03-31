import 'package:kammun_app/models/models_importer.dart';

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
        id: json['id'],
        username: json['username'],
        name: json['name'],
        phone: json['phone'],
        apiToken: json['api_token'],
        productOperationsPermission: json['product_operations_permission'],
        addCategoryPermission: json['add_category_permission'],
        addSpecialOfferPermission: json['add_special_offer_permission'],
        viewOrdersPermission: json['view_orders_permission'],
        banUserPermission: json['ban_user_permission'],
        viewReportPermission: json['view_report_permission'],
        addNotificationPermission: json['add_notification_permission'],
        warehouseId: json['warehouse_id'],
        firebaseToken: json['firebase_token'],
        updateCategoryWarehousePermission: json['update_category_warehouse_permission'],
        productWarehouseOperationsPermission: json['product_warehouse_operations_permission'],
        updateOrderPermission: json['update_order_permission'],
        subWarehouses: json['sub_warehouses'] == null
            ? null
            : List<SubWarehouse>.from(json['sub_warehouses'].map((x) => SubWarehouse.fromJson(x))),
        roles: json['roles'] == null ? null : List<Role>.from(json['roles'].map((x) => Role.fromJson(x))),
        permissions: json['permissions'] == null
            ? null
            : List<Permission>.from(json['permissions'].map((x) => Permission.fromJson(x))),
        shopper: json['shopper'] == null ? null : ShopperModel.fromJson(json['shopper']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'name': name,
        'phone': phone,
        'api_token': apiToken,
        'product_operations_permission': productOperationsPermission,
        'add_category_permission': addCategoryPermission,
        'add_special_offer_permission': addSpecialOfferPermission,
        'view_orders_permission': viewOrdersPermission,
        'ban_user_permission': banUserPermission,
        'view_report_permission': viewReportPermission,
        'add_notification_permission': addNotificationPermission,
        'warehouse_id': warehouseId,
        'firebase_token': firebaseToken,
        'update_category_warehouse_permission': updateCategoryWarehousePermission,
        'product_warehouse_operations_permission': productWarehouseOperationsPermission,
        'update_order_permission': updateOrderPermission,
        'sub_warehouses': subWarehouses == null ? null : List<dynamic>.from(subWarehouses.map((x) => x.toJson())),
        'roles': roles == null ? null : List<dynamic>.from(roles.map((x) => x.toJson())),
        'permissions': permissions == null ? null : List<dynamic>.from(permissions.map((x) => x.toJson())),
      };
}
