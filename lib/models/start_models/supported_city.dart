import 'dart:convert';

import 'package:kammun_app/utils/tools.dart';

import 'start_model_importer.dart';

SupportedCityOriginal supportedCityOriginalFromJson(String str) =>
    SupportedCityOriginal.fromJson(json.decode(str));

class SupportedCity {
  SupportedCity({
    this.headers,
    this.original,
    this.exception,
  });

  Headers headers;
  SupportedCityOriginal original;
  dynamic exception;

  factory SupportedCity.fromJson(Map<String, dynamic> json) => SupportedCity(
        headers: Headers.fromJson(json["headers"]),
        original: SupportedCityOriginal.fromJson(json["original"]),
        exception: json["exception"],
      );

  Map<String, dynamic> toJson() => {
        "headers": headers.toJson(),
        "original": original.toJson(),
        "exception": exception,
      };
}

class SupportedCityOriginal {
  SupportedCityOriginal({
    this.success,
    this.data,
  });

  bool success;
  List<IndigoDatum> data;

  factory SupportedCityOriginal.fromJson(Map<String, dynamic> json) => SupportedCityOriginal(
        success: json["success"],
        data: List<IndigoDatum>.from(json["data"].map((x) => IndigoDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class IndigoDatum {
  IndigoDatum({
    this.id,
    this.name,
    this.deliveryPrice,
    this.warehouseId,
    this.couponTypeId,
    this.isActive,
    this.maintenanceMessages,
    this.supportPhoneNumber,
    this.warehouse,
  });

  String id;
  String name;
  String deliveryPrice;
  String warehouseId;
  String couponTypeId;
  String isActive;
  Warehouse warehouse;
  String supportPhoneNumber;
  String maintenanceMessages;

  factory IndigoDatum.fromJson(Map<String, dynamic> json) {
    Tools.logToConsole('tffff 1');
    IndigoDatum(
      id: json["id"].toString(),
      name: json["name"],
      deliveryPrice: json["delivery_price"].toString(),
      warehouseId: json["warehouse_id"].toString(),
      couponTypeId: json["coupon_type_id"].toString(),
      isActive: json["is_active"].toString(),
      supportPhoneNumber: json["support_phone_number"].toString(),
      maintenanceMessages: json["maintenance_messages"].toString(),
      warehouse: Warehouse.fromJson(
        json["warehouse"],
      ),
    );
    Tools.logToConsole('tffff 2');
    return IndigoDatum(
      id: json["id"].toString(),
      name: json["name"],
      deliveryPrice: json["delivery_price"].toString(),
      warehouseId: json["warehouse_id"].toString(),
      couponTypeId: json["coupon_type_id"].toString(),
      isActive: json["is_active"].toString(),
      supportPhoneNumber: json["support_phone_number"].toString(),
      maintenanceMessages: json["maintenance_messages"].toString(),
      warehouse: Warehouse.fromJson(
        json["warehouse"],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "delivery_price": deliveryPrice,
        "warehouse_id": warehouseId,
        "coupon_type_id": couponTypeId,
        "is_active": isActive,
        "maintenance_messages": maintenanceMessages,
        "support_phone_number": supportPhoneNumber,
        "warehouse": warehouse.toJson(),
      };
}
