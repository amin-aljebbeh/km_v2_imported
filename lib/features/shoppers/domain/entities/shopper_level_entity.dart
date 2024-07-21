import '../../../general_information/domain/entities/sub_warehouse_entity.dart';
import '../../../general_information/domain/entities/supported_city_entity.dart';

class ShopperLevelEntity {
  ShopperLevelEntity({this.id, this.subWarehouses, this.pricePerKilo, this.supportedCities});

  int id;
  String pricePerKilo;
  List<SubWarehouseEntity> subWarehouses;
  List<SupportedCityEntity> supportedCities;
}
