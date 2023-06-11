import 'package:kammun_app/features/general_information/data/models/supported_city_level_pivot_model.dart';
import 'package:kammun_app/features/general_information/domain/entities/supported_city_entity.dart';

class SupportedCitiesResponse {
  SupportedCitiesResponse({this.success, this.cities});

  bool success;
  List<SupportedCityModel> cities;

  factory SupportedCitiesResponse.fromJson(Map<String, dynamic> json) => SupportedCitiesResponse(
        success: json["success"],
        cities: List<SupportedCityModel>.from(json["data"].map((x) => SupportedCityModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(cities.map((x) => x.toJson())),
      };
}

class SupportedCityModel extends SupportedCityEntity {
  SupportedCityModel({
    id,
    name,
    deliveryPrice,
    warehouseId,
    couponTypeId,
    isActive,
    supportPhoneNumber,
    maintenanceMessages,
    levelPivot,
  }) : super(
          id: id,
          name: name,
          deliveryPrice: deliveryPrice,
          warehouseId: warehouseId,
          couponTypeId: couponTypeId,
          isActive: isActive,
          supportPhoneNumber: supportPhoneNumber,
          maintenanceMessages: maintenanceMessages,
          levelPivot: levelPivot,
        );

  factory SupportedCityModel.fromJson(Map<String, dynamic> json) => SupportedCityModel(
        id: json['id'].toString(),
        name: json['name'],
        deliveryPrice: double.parse(json['delivery_price']),
        warehouseId: json['warehouse_id'].toString(),
        couponTypeId: json['coupon_type_id'].toString(),
        isActive: json['is_active'].toString(),
        supportPhoneNumber: json['support_phone_number'],
        maintenanceMessages: json['maintenance_messages'],
        levelPivot: json['pivot'] == null ? null : SupportedCityLevelPivotModel.fromJson(json['pivot']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'warehouse_id': warehouseId,
      };
}
