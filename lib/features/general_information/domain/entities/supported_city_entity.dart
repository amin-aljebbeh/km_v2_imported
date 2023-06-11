import 'package:kammun_app/features/general_information/domain/entities/supported_city_level_pivot_entity.dart';

class SupportedCityEntity {
  final String id;
  final String name;
  final double deliveryPrice;
  final String warehouseId;
  final String couponTypeId;
  final String isActive;
  final String supportPhoneNumber;
  final String maintenanceMessages;
  final SupportedCityLevelPivotEntity levelPivot;

  SupportedCityEntity({
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
}
