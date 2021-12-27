import 'dart:convert';

import 'package:kammun_app/models/supported_city_level_pivot.dart';

import 'sub_warehouse_level_pivot.dart';
import 'sub_warehouse_pivot.dart';

List<SupportedCity> subWarehouseFromJson(String str) =>
    List<SupportedCity>.from(
        json.decode(str).map((x) => SupportedCity.fromJson(x)));

String subWarehouseToJson(List<SupportedCity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SupportedCity {
  SupportedCity({
    this.id,
    this.name,
    this.deliveryPrice,
    this.warehouseId,
    this.couponTypeId,
    this.isActive,
    this.supportPhoneNumber,
    this.maintenanceMessages,
    this.levelPivot,
  });

  String id;
  String name;
  double deliveryPrice;
  String warehouseId;
  String couponTypeId;
  String isActive;
  String supportPhoneNumber;
  String maintenanceMessages;
  SupportedCityLevelPivot levelPivot;

  factory SupportedCity.fromJson(Map<String, dynamic> json) => SupportedCity(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        deliveryPrice: json["delivery_price"] == null
            ? null
            : double.parse(json["delivery_price"]),
        warehouseId: json["warehouse_id"] == null ? null : json["warehouse_id"],
        couponTypeId:
            json["coupon_type_id"] == null ? null : json['coupon_type_id'],
        isActive: json["is_active"] == null ? null : json["is_active"],
        supportPhoneNumber: json["support_phone_number"] == null
            ? null
            : json["support_phone_number"],
        maintenanceMessages: json["maintenance_messages"] == null
            ? null
            : json["maintenance_messages"],
        levelPivot: json["pivot"] == null
            ? null
            : SupportedCityLevelPivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "warehouse_id": warehouseId == null ? null : warehouseId,
      };
}
