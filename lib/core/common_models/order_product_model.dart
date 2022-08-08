import '../core_importer.dart';

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
  });

  int id;
  String name;
  String description;
  String unit;
  String isInFacebook;
  String categoryId;
  String quantity;

  OrderProductPivot pivot;

  List<ProductImage> images;

  factory OrderProducts.fromJson(Map<String, dynamic> json) => OrderProducts(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        unit: json['unit'],
        isInFacebook: json['is_in_facebook'].toString(),
        categoryId: json['category_id'].toString(),
        quantity: json['quantity'].toString(),
        pivot: OrderProductPivot.fromJson(json['pivot']),
        images: List<ProductImage>.from(json['images'].map((x) => ProductImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'unit': unit,
        'is_in_facebook': isInFacebook,
        'category_id': categoryId,
        'quantity': quantity,
        'pivot': pivot.toJson(),
        'images': List<dynamic>.from(images.map((x) => x.toJson())),
      };
}

class OrderProductPivot {
  OrderProductPivot({
    this.orderId,
    this.productId,
    this.purchasePrice,
    this.quantity,
    this.createdAt,
    this.deletedAt,
    this.updatedAt,
  });

  String orderId;
  String productId;
  String purchasePrice;
  DateTime createdAt;
  String deletedAt;
  DateTime updatedAt;
  String quantity;

  factory OrderProductPivot.fromJson(Map<String, dynamic> json) => OrderProductPivot(
        orderId: json['order_id'].toString(),
        productId: json['product_id'].toString(),
        purchasePrice: json['purchase_price'].toString(),
        quantity: json['quantity'].toString(),
        deletedAt: json['deleted_at'].toString(),
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'order_id': orderId,
        'product_id': productId,
        'purchase_price': purchasePrice,
        'quantity': quantity,
      };
}
