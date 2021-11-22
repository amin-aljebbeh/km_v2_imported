class Level {
  Level({
    this.id,
    this.name,
    this.description,
    this.maxProductsToHandle,
    this.maxOrdersToHandle,
    this.points,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  dynamic description;
  int maxProductsToHandle;
  int maxOrdersToHandle;
  int points;
  DateTime createdAt;
  dynamic updatedAt;

  factory Level.fromJson(Map<String, dynamic> json) => Level(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"],
        maxProductsToHandle: json["max_products_to_handle"] == null
            ? null
            : json["max_products_to_handle"],
        maxOrdersToHandle: json["max_orders_to_handle"] == null
            ? null
            : json["max_orders_to_handle"],
        points: json["points"] == null ? null : json["points"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "description": description,
        "max_products_to_handle":
            maxProductsToHandle == null ? null : maxProductsToHandle,
        "max_orders_to_handle":
            maxOrdersToHandle == null ? null : maxOrdersToHandle,
        "points": points == null ? null : points,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt,
      };
}
