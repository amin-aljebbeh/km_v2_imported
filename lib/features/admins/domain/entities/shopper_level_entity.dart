import '../../../../core/core_importer.dart';

class ShopperLevelEntity {
  ShopperLevelEntity({
    this.id,
    this.name,
    this.description,
    this.maxProductsToHandle,
    this.maxOrdersToHandle,
    this.maxCompanyBalance,
    this.points,
    this.createdAt,
    this.updatedAt,
    this.subWarehouses,
    this.pricePerKilo,
    this.supportedCities,
  });

  int id;
  String name;
  String description;
  int maxProductsToHandle;
  int maxOrdersToHandle;
  int maxCompanyBalance;
  int points;
  DateTime createdAt;
  DateTime updatedAt;
  String pricePerKilo;
  List<SubWarehouse> subWarehouses;
  List<SupportedCity> supportedCities;
}
