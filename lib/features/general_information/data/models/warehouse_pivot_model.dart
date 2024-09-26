import '../../domain/entities/warehouse_pivot_entity.dart';

class WarehousePivotModel extends WarehousePivotEntity {
  WarehousePivotModel({
    String subWarehouseId,
    String isActive,
    String priority,
    String supplierCode,
    String price,
  }) : super(
          subWarehouseId: subWarehouseId,
          isActive: isActive,
          priority: priority,
          supplierCode: supplierCode,
          price: price,
        );

  factory WarehousePivotModel.fromJson(Map<String, dynamic> json) => WarehousePivotModel(
        subWarehouseId: json['sub_warehouse_id'].toString(),
        price: json['price'].toString(),
        isActive: json['is_active'].toString(),
        priority: json['priority'].toString(),
        supplierCode: json['supplier_code'] != null ? json['supplier_code'].toString() : 'null',
      );

  Map<String, dynamic> toJson() => {
        'is_active': isActive,
        'price': price,
        'priority': priority,
      };
}
