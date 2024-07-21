import 'package:kammun_app/features/general_information/domain/entities/warehouse_entity.dart';

import 'warehouse_pivot_model.dart';

class WarehouseModel extends WarehouseEntity {
  WarehouseModel({int id, String name, int isActive, pivot})
      : super(id: id, name: name, isActive: isActive, pivot: pivot);

  factory WarehouseModel.fromJson(Map<String, dynamic> json) => WarehouseModel(
        pivot: json['pivot'] == null ? null : WarehousePivotModel.fromJson(json['pivot']),
        id: json['id'],
        name: json['name'],
        isActive: json['is_active'],
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'is_active': isActive};
}
