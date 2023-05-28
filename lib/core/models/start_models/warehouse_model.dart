class Warehouse {
  Warehouse({
    this.id,
    this.name,
    this.description,
    this.numberOfWorkers,
    this.isActive,
    this.pivot,
    this.shopperAlgorithmId,
  });

  int id;
  int shopperAlgorithmId;
  String name;
  String description;
  String numberOfWorkers;
  int isActive;
  WarehousePivot pivot;

  factory Warehouse.fromJson(Map<String, dynamic> json) => Warehouse(
        pivot: json['pivot'] == null ? null : WarehousePivot.fromJson(json['pivot']),
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
        'pivot': pivot.toJson(),
      };
}

class WarehousePivot {
  WarehousePivot({
    this.warehouseId,
    this.isActive,
    this.isFeatured,
    this.priority,
    this.numberOfVisits,
    this.price,
    this.supplierCode,
    this.subWarehouseId,
  });

  String warehouseId;
  String subWarehouseId;
  String isActive;
  String isFeatured;
  String priority;
  String numberOfVisits;
  String supplierCode;
  String price;

  factory WarehousePivot.fromJson(Map<String, dynamic> json) => WarehousePivot(
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
