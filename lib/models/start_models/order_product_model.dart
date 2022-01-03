class OrderProducts {
  OrderProducts({
    this.id,
    this.name,
    this.description,
    this.unit,
    this.isInFacebook,
    this.categoryId,
    this.quantity,
    this.pivot,
    this.images,
    this.supplierCode,
    this.productAvailable,
    this.subWarehouseId,
    this.isActive,
  });

  int id;
  String name;
  String description;
  String unit;
  String isInFacebook;
  String categoryId;
  String quantity;
  String supplierCode;
  bool productAvailable;
  int subWarehouseId;
  OrderProductPivot pivot;
  int isActive;

  List<ProductImage> images;

  factory OrderProducts.fromJson(Map<String, dynamic> json) => OrderProducts(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        unit: json["unit"].toString(),
        isInFacebook: json["is_in_facebook"].toString(),
        categoryId: json["category_id"].toString(),
        supplierCode: json["supplier_code"].toString(),
        isActive: json["is_active"],
        subWarehouseId:
            json["sub_warehouse_id"] == null ? null : json["sub_warehouse_id"],
        quantity: json["quantity"].toString(),
        productAvailable: false,
        pivot: OrderProductPivot.fromJson(json["pivot"]),
        images: List<ProductImage>.from(
            json["images"].map((x) => ProductImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "unit": unit,
        "is_in_facebook": isInFacebook,
        "category_id": categoryId,
        "quantity": quantity,
        "pivot": pivot.toJson(),
        "supplier_code": supplierCode,
        "sub_warehouse_id": subWarehouseId,
        "product_available": productAvailable,
        "is_active": isActive,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
      };

  static sort() {}
}

class ProductImage {
  ProductImage({
    this.id,
    this.productId,
    this.imageFileName,
  });

  int id;
  String productId;
  String imageFileName;

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
        id: json["id"],
        productId: json["product_id"].toString(),
        imageFileName: json["image_file_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "image_file_name": imageFileName,
      };
}

class OrderProductPivot {
  OrderProductPivot({
    this.orderId,
    this.productId,
    this.purchasePrice,
    this.quantity,
    this.deletedAt,
    this.increaseValue,
  });

  String orderId;
  String productId;
  String purchasePrice;
  String deletedAt;
  String quantity;
  int increaseValue;

  factory OrderProductPivot.fromJson(Map<String, dynamic> json) =>
      OrderProductPivot(
        orderId: json["order_id"].toString(),
        productId: json["product_id"].toString(),
        purchasePrice: json["purchase_price"].toString(),
        quantity: json["quantity"].toString(),
        deletedAt: json["deleted_at"],
        increaseValue:
            json["increase_value"] == null ? 0 : json["increase_value"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "product_id": productId,
        "purchase_price": purchasePrice,
        "quantity": quantity,
        "deleted_at": deletedAt
      };
}
