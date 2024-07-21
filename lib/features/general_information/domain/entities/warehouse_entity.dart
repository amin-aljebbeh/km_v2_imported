import 'package:kammun_app/features/general_information/domain/entities/warehouse_pivot_entity.dart';

class WarehouseEntity {
  final int id;
  final String name;
  final int isActive;
  final WarehousePivotEntity pivot;

  WarehouseEntity({this.id, this.name, this.isActive, this.pivot});
}
