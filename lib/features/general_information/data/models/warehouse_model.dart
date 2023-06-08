import 'package:kammun_app/features/general_information/domain/entities/warehouse_entity.dart';

import 'warehouse_pivot_model.dart';

class WarehouseModel extends WarehouseEntity {
  WarehouseModel({
    int id,
    int shopperAlgorithmId,
    String name,
    String description,
    String numberOfWorkers,
    int isActive,
    pivot,
  }) : super(
          id: id,
          shopperAlgorithmId: shopperAlgorithmId,
          name: name,
          description: description,
          numberOfWorkers: numberOfWorkers,
          isActive: isActive,
          pivot: pivot,
        );

  factory WarehouseModel.fromJson(Map<String, dynamic> json) => WarehouseModel(
        pivot: json['pivot'] == null ? null : WarehousePivotModel.fromJson(json['pivot']),
        id: json['id'],
        name: json['name'],
        description: json['description'],
        numberOfWorkers: json['number_of_workers'].toString(),
        shopperAlgorithmId: json['shopper_algorithm_id'],
        isActive: json['is_active'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'number_of_workers': numberOfWorkers,
        'is_active': isActive,
      };
}
