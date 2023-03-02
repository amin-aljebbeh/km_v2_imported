// To parse this JSON data, do
//
//     final subWarehouse = subWarehouseFromJson(jsonString);

import 'package:kammun_app/core/static_variables.dart';

import 'models_importer.dart';

List<SubWarehouse> subWarehouseFromJson(String str) =>
    List<SubWarehouse>.from(json.decode(str).map((x) => SubWarehouse.fromJson(x)));

String subWarehouseToJson(List<SubWarehouse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubWarehouse {
  SubWarehouse({
    this.id,
    this.name,
    this.levelPivot,
    this.discountPercentage,
    this.directDiscount,
    this.allowShopperAssign,
  });

  int id;
  String name;
  int directDiscount;
  SubWarehouseLevelPivot levelPivot;
  double discountPercentage;
  String allowShopperAssign;

  static double getDiscountPercentage(int subWarehouseId) => (StaticVariables.subWarehouses
          .firstWhere((subWarehouse) => subWarehouse.id == subWarehouseId,
              orElse: () => SubWarehouse(discountPercentage: 1))
          .discountPercentage /
      100);

  factory SubWarehouse.fromJson(Map<String, dynamic> json) => SubWarehouse(
        id: json["id"],
        name: json["name"],
        levelPivot: json["pivot"]["level_id"] == null ? null : SubWarehouseLevelPivot.fromJson(json["pivot"]),
        discountPercentage: json["discount_percentage"] == null ? null : double.parse(json["discount_percentage"]),
        directDiscount: json['direct_discount'],
        allowShopperAssign: json['allow_shopper_assign'].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "discount_percentage": discountPercentage,
      };
}
