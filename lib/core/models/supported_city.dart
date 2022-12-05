import 'models_importer.dart';

List<SupportedCity> subWarehouseFromJson(String str) =>
    List<SupportedCity>.from(json.decode(str).map((x) => SupportedCity.fromJson(x)));

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
        id: json["id"].toString(),
        name: json["name"],
        deliveryPrice: double.parse(json["delivery_price"]),
        warehouseId: json["warehouse_id"].toString(),
        couponTypeId: json['coupon_type_id'].toString(),
        isActive: json["is_active"].toString(),
        supportPhoneNumber: json["support_phone_number"],
        maintenanceMessages: json["maintenance_messages"],
        levelPivot: SupportedCityLevelPivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "warehouse_id": warehouseId,
      };
}
