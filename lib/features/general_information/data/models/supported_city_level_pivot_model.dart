import '../../domain/entities/supported_city_level_pivot_entity.dart';

class SupportedCityLevelPivotModel extends SupportedCityLevelPivotEntity {
  SupportedCityLevelPivotModel({deliveryProfitPercentage}) : super(deliveryProfitPercentage: deliveryProfitPercentage);

  factory SupportedCityLevelPivotModel.fromJson(Map<String, dynamic> json) => SupportedCityLevelPivotModel(
        deliveryProfitPercentage:
            json['delivery_profit_percentage'] == null ? null : double.parse(json['delivery_profit_percentage']),
      );

  Map<String, dynamic> toJson() => {'delivery_profit_percentage': deliveryProfitPercentage};
}
