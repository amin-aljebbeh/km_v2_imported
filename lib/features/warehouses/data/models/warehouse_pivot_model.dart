import 'package:kammun_app/features/warehouses/domain/entities/warehouse_pivot_entity.dart';

class WarehousePivotModel extends WarehousePivotEntity {
  WarehousePivotModel({
    String warehouseId,
    String subWarehouseId,
    String isActive,
    String isFeatured,
    String priority,
    String numberOfVisits,
    String supplierCode,
    String price,
  }) : super(
          warehouseId: warehouseId,
          subWarehouseId: subWarehouseId,
          isActive: isActive,
          isFeatured: isFeatured,
          priority: priority,
          numberOfVisits: numberOfVisits,
          supplierCode: supplierCode,
          price: price,
        );

  factory WarehousePivotModel.fromJson(Map<String, dynamic> json) => WarehousePivotModel(
        subWarehouseId: json['sub_warehouse_id'].toString(),
        warehouseId: json['warehouse_id'].toString(),
        price: json['price'].toString(),
        isActive: json['is_active'].toString(),
        isFeatured: json['is_featured'].toString(),
        priority: json['priority'].toString(),
        numberOfVisits: json['number_of_visits'].toString(),
        supplierCode: json['supplier_code'] != null ? json['supplier_code'].toString() : 'null',
      );

  Map<String, dynamic> toJson() => {
        'warehouse_id': warehouseId,
        'is_active': isActive,
        'price': price,
        'is_featured': isFeatured,
        'priority': priority,
        'number_of_visits': numberOfVisits,
      };
}
