// To parse this JSON data, do
//
//     final subWarehouse = subWarehouseFromJson(jsonString);

import 'package:kammun_app/features/loading/loading_services.dart';

import 'models_importer.dart';

List<SubWarehouse> subWarehouseFromJson(String str) =>
    List<SubWarehouse>.from(json.decode(str).map((x) => SubWarehouse.fromJson(x)));

String subWarehouseToJson(List<SubWarehouse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubWarehouse {
  SubWarehouse({
    this.id,
    this.name,
    this.description,
    this.phone,
    this.businessDomain,
    this.accountingSystemId,
    this.warehouseId,
    this.adminPivot,
    this.levelPivot,
    this.discountPercentage,
    this.directDiscount,
    this.allowShopperAssign,
  });

  int id;
  String name;
  String description;
  String phone;
  String businessDomain;
  int accountingSystemId;
  int warehouseId;
  int directDiscount;
  SubWarehouseAdminPivot adminPivot;
  SubWarehouseLevelPivot levelPivot;
  double discountPercentage;
  String allowShopperAssign;

  static double getDiscountPercentage(int subWarehouseId) => (LoadingScreenServices.subWarehouses
          .firstWhere((subWarehouse) => subWarehouse.id == subWarehouseId,
              orElse: () => SubWarehouse(discountPercentage: 1))
          .discountPercentage /
      100);

  factory SubWarehouse.fromJson(Map<String, dynamic> json) => SubWarehouse(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        phone: json["phone"],
        businessDomain: json["business_domain"],
        accountingSystemId: json["accounting_system_id"],
        warehouseId: json["warehouse_id"],
        adminPivot: json["pivot"]["admin_id"] == null ? null : SubWarehouseAdminPivot.fromJson(json["pivot"]),
        levelPivot: json["pivot"]["level_id"] == null ? null : SubWarehouseLevelPivot.fromJson(json["pivot"]),
        discountPercentage: json["discount_percentage"] == null ? null : double.parse(json["discount_percentage"]),
        directDiscount: json['direct_discount'],
        allowShopperAssign: json['allow_shopper_assign'].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "phone": phone,
        "business_domain": businessDomain,
        "accounting_system_id": accountingSystemId,
        "warehouse_id": warehouseId,
        "pivot": adminPivot.toJson(),
        "discount_percentage": discountPercentage,
      };
}
