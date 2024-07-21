import 'package:kammun_app/features/general_information/domain/entities/supported_city_level_pivot_entity.dart';

class SupportedCityEntity {
  final String id;
  final String name;
  final String warehouseId;
  final String isActive;
  final SupportedCityLevelPivotEntity levelPivot;

  SupportedCityEntity({this.id, this.name, this.warehouseId, this.isActive, this.levelPivot});
}
