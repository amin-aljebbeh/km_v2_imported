import '../../domain/entities/supported_city_level_pivot_entity.dart';

class SupportedCityLevelPivotModel extends SupportedCityLevelPivotEntity {
  SupportedCityLevelPivotModel({levelId, supportedCityId, deliveryProfitPercentage})
      : super(supportedCityId: supportedCityId, levelId: levelId, deliveryProfitPercentage: deliveryProfitPercentage);

  factory SupportedCityLevelPivotModel.fromJson(Map<String, dynamic> json) => SupportedCityLevelPivotModel(
        levelId: json['level_id'],
        supportedCityId: json['sub_warehouse_id'],
        deliveryProfitPercentage:
            json['delivery_profit_percentage'] == null ? null : double.parse(json['delivery_profit_percentage']),
      );

  Map<String, dynamic> toJson() => {
        'level_id': levelId,
        'sub_warehouse_id': supportedCityId,
        'delivery_profit_percentage': deliveryProfitPercentage,
      };
}
