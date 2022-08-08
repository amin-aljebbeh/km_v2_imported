// To parse this JSON data, do
//
//     final deliveryMethod = deliveryMethodFromJson(jsonString);

import 'dart:convert';

DeliveryMethod deliveryMethodFromJson(String str) => DeliveryMethod.fromJson(json.decode(str));

String deliveryMethodToJson(DeliveryMethod data) => json.encode(data.toJson());

class DeliveryMethod {
  DeliveryMethod({
    this.success,
    this.data,
  });

  bool success;
  List<DeliveryMethodData> data;

  factory DeliveryMethod.fromJson(Map<String, dynamic> json) => DeliveryMethod(
        success: json['success'],
        data: List<DeliveryMethodData>.from(json['data'].map((x) => DeliveryMethodData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DeliveryMethodData {
  DeliveryMethodData({
    this.id,
    this.name,
    this.pivot,
  });

  int id;
  String name;
  Pivot pivot;

  factory DeliveryMethodData.fromJson(Map<String, dynamic> json) => DeliveryMethodData(
        id: json['id'],
        name: json['name'],
        pivot: Pivot.fromJson(json['pivot']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'pivot': pivot.toJson(),
      };
}

class Pivot {
  Pivot({
    this.supportedCityId,
    this.deliveryMethodId,
    this.price,
    this.isActive,
    this.message,
  });

  String supportedCityId;
  String deliveryMethodId;
  String price;
  String isActive;
  String message;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        supportedCityId: json['supported_city_id'].toString(),
        deliveryMethodId: json['delivery_method_id'].toString(),
        price: json['price'].toString(),
        isActive: json['is_active'].toString(),
        message: json['message'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'supported_city_id': supportedCityId,
        'delivery_method_id': deliveryMethodId,
        'price': price,
        'is_active': isActive,
        'message': message,
      };
}
