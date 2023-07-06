import '../../domain/entities/statistics_supported_city_entity.dart';

class StatisticsSupportedCityModel extends StatisticsSupportedCityEntity {
  StatisticsSupportedCityModel({supportedCityId, name, deliveryIncome, ordersCount, deliveryPrice})
      : super(
          supportedCityId: supportedCityId,
          name: name,
          deliveryIncome: deliveryIncome,
          ordersCount: ordersCount,
          deliveryPrice: deliveryPrice,
        );

  factory StatisticsSupportedCityModel.fromJson(Map<String, dynamic> json) => StatisticsSupportedCityModel(
        supportedCityId: json['supported_city_id'],
        name: json['name'],
        deliveryIncome: json['delivery_income'],
        ordersCount: json['orders_count'],
        deliveryPrice: json['delivery_price'],
      );

  Map<String, dynamic> toJson() => {
        'supported_city_id': supportedCityId,
        'name': name,
        'delivery_income': deliveryIncome,
        'orders_count': ordersCount,
        'delivery_price': deliveryPrice,
      };
}
