import '../../../../core/core_importer.dart';
import '../../domain/entities/shopper_level_entity.dart';

class ShopperLevelModel extends ShopperLevelEntity {
  ShopperLevelModel({
    id,
    name,
    description,
    maxProductsToHandle,
    maxOrdersToHandle,
    maxCompanyBalance,
    points,
    subWarehouses,
    supportedCities,
    pricePerKilo,
  }) : super(
          id: id,
          name: name,
          description: description,
          maxProductsToHandle: maxProductsToHandle,
          maxOrdersToHandle: maxOrdersToHandle,
          maxCompanyBalance: maxCompanyBalance,
          points: points,
          subWarehouses: subWarehouses,
          supportedCities: supportedCities,
          pricePerKilo: pricePerKilo,
        );

  factory ShopperLevelModel.fromJson(Map<String, dynamic> json) => ShopperLevelModel(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        maxProductsToHandle: json['max_products_to_handle'],
        maxOrdersToHandle: json['max_orders_to_handle'],
        maxCompanyBalance: json['max_company_balance'],
        points: json['points'],
        pricePerKilo: json['price_per_kilo'],
        subWarehouses: json['sub_warehouses'] == null
            ? null
            : List<SubWarehouse>.from(json['sub_warehouses'].map((x) => SubWarehouse.fromJson(x))),
        supportedCities: json['supported_cities'] == null
            ? null
            : List<SupportedCity>.from(json['supported_cities'].map((x) => SupportedCity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'max_products_to_handle': maxProductsToHandle,
        'max_orders_to_handle': maxOrdersToHandle,
        'points': points,
      };
}
