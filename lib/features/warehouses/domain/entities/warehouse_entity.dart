import 'package:kammun_app/features/warehouses/domain/entities/warehouse_pivot_entity.dart';

class WarehouseEntity {
  final int id;
  final int shopperAlgorithmId;
  final String name;
  final String description;
  final String numberOfWorkers;
  final int isActive;
  final WarehousePivotEntity pivot;

  WarehouseEntity(
      {this.id, this.shopperAlgorithmId, this.name, this.description, this.numberOfWorkers, this.isActive, this.pivot});
}
