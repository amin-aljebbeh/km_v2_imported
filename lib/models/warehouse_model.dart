class Warehouse {
  Warehouse({
    this.id,
    this.name,
    this.description,
    this.numberOfWorkers,
    this.isActive,
    this.pivot,
  });

  int id;
  String name;
  String description;
  String numberOfWorkers;
  String isActive;
  WarehousePivot pivot;

  factory Warehouse.fromJson(Map<String, dynamic> json) => Warehouse(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        numberOfWorkers: json["number_of_workers"].toString(),
        isActive: json["is_active"].toString(),
        pivot: json["pivot"] == null ? null : WarehousePivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "number_of_workers": numberOfWorkers,
        "is_active": isActive,
        "pivot": pivot == null ? null : pivot.toJson(),
      };
}

class WarehousePivot {
  WarehousePivot({
    this.categoryId,
    this.warehouseId,
    this.isActive,
    this.isFeatured,
    this.priority,
    this.numberOfVisits,
    this.price,
  });

  String categoryId;
  String warehouseId;
  String isActive;
  String isFeatured;
  String priority;
  String numberOfVisits;

  String price;

  factory WarehousePivot.fromJson(Map<String, dynamic> json) => WarehousePivot(
        categoryId: json["category_id"].toString(),
        warehouseId: json["warehouse_id"].toString(),
        price: json["price"].toString(),
        isActive: json["is_active"].toString(),
        isFeatured: json["is_featured"].toString(),
        priority: json["priority"].toString(),
        numberOfVisits: json["number_of_visits"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "warehouse_id": warehouseId,
        "is_active": isActive,
        "price": price,
        "is_featured": isFeatured,
        "priority": priority,
        "number_of_visits": numberOfVisits,
      };
}
