import 'package:kammun_app/core/core_importer.dart';

SupportedCityResponseModel supportedCityResponseModelFromJson(String str) =>
    SupportedCityResponseModel.fromJson(json.decode(str));

String supportedCityResponseModelToJson(SupportedCityResponseModel data) => json.encode(data.toJson());

class SupportedCityResponseModel {
  SupportedCityResponseModel({
    this.success,
    this.data,
  });

  bool success;
  List<SupportedCityModel> data;

  factory SupportedCityResponseModel.fromJson(Map<String, dynamic> json) => SupportedCityResponseModel(
        success: json['success'],
        data: List<SupportedCityModel>.from(json['data'].map((x) => SupportedCityModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class SupportedCityModel {
  SupportedCityModel({
    this.id,
    this.name,
    this.deliveryPrice,
    this.warehouseId,
    this.couponTypeId,
    this.isActive,
    this.supportPhoneNumber,
    this.maintenanceMessages,
    this.polygonPoints,
    this.activeChat,
  });

  int id;
  String name;
  String deliveryPrice;
  int warehouseId;
  int couponTypeId;
  int isActive;
  String supportPhoneNumber;
  String maintenanceMessages;
  List<SupportedCityPolygon> polygonPoints;
  int activeChat;

  factory SupportedCityModel.fromJson(Map<String, dynamic> json) => SupportedCityModel(
        id: json['id'],
        name: json['name'].toString(),
        deliveryPrice: json['delivery_price'].toString(),
        warehouseId: json['warehouse_id'],
        couponTypeId: json['coupon_type_id'],
        isActive: json['is_active'],
        supportPhoneNumber: json['support_phone_number'].toString(),
        maintenanceMessages: json['maintenance_messages'].toString(),
        polygonPoints: json['polygon'] == null
            ? null
            : List<SupportedCityPolygon>.from(json['polygon'].map((x) => SupportedCityPolygon.fromJson(x))),
        activeChat: json['chat_active'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'delivery_price': deliveryPrice,
        'warehouse_id': warehouseId,
        'coupon_type_id': couponTypeId,
        'is_active': isActive,
        'support_phone_number': supportPhoneNumber,
        'maintenance_messages': maintenanceMessages,
      };
}

class SupportedCityPolygon {
  SupportedCityPolygon({
    this.supportedCityId,
    this.lon,
    this.lat,
  });

  int supportedCityId;
  double lon;
  double lat;

  factory SupportedCityPolygon.fromJson(Map<String, dynamic> json) => SupportedCityPolygon(
        supportedCityId: json['supported_city_id'],
        lon: json['lon'].toDouble(),
        lat: json['lat'].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'supported_city_id': supportedCityId,
        'lon': lon,
        'lat': lat,
      };
}
