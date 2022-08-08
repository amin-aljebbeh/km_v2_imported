class ProductAlert {
  ProductAlert({
    this.id,
    this.productId,
    this.warehouseId,
    this.userId,
    this.status,
    this.isAlways,
    this.numActivate,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int productId;
  int warehouseId;
  int userId;
  int status;
  int isAlways;
  int numActivate;
  DateTime createdAt;
  DateTime updatedAt;

  factory ProductAlert.fromJson(Map<String, dynamic> json) => ProductAlert(
        id: json['id'],
        productId: json['product_id'],
        warehouseId: json['warehouse_id'],
        userId: json['user_id'],
        status: json['status'],
        isAlways: json['is_always'],
        numActivate: json['num_activate'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id': productId,
        'warehouse_id': warehouseId,
        'user_id': userId,
        'status': status,
        'is_always': isAlways,
        'num_activate': numActivate,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}
