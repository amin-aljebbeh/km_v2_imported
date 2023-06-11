import '../../../general_information/domain/entities/sub_warehouse_entity.dart';
import '../../../general_information/domain/entities/supported_city_entity.dart';

class ShopperLevelEntity {
  ShopperLevelEntity({
    this.id,
    this.name,
    this.description,
    this.maxProductsToHandle,
    this.maxOrdersToHandle,
    this.maxCompanyBalance,
    this.points,
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
  String pricePerKilo;
  List<SubWarehouseEntity> subWarehouses;
  List<SupportedCityEntity> supportedCities;
}
