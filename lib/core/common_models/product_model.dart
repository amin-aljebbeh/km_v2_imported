import '../core_importer.dart';

class ProductData {
  ProductData({
    this.id,
    this.name,
    this.description,
    this.unit,
    this.categoryId,
    this.price,
    this.isActive,
    this.quantity,
    this.productCount,
    this.images,
    this.priority,
    this.productAlert,
    this.newPrice,
    this.subWarehouseId,
    this.alertId,
    this.maxCount,
  });

  int id;
  int subWarehouseId;
  String name;
  String description;
  String unit;
  String categoryId;
  String price;
  String newPrice;
  String isActive;
  String quantity;
  int productCount;
  int priority;
  List<ProductImage> images;
  ProductAlert productAlert;
  String alertId;
  String maxCount;

  ProductData copyWith({
    int id,
    String name,
    String description,
    String unit,
    String categoryId,
    String price,
    String newPrice,
    String isActive,
    String quantity,
    int productCount,
    int priority,
    List<ProductImage> images,
    ProductAlert productAlert,
    int subWarehouseId,
    String maxCount,
  }) {
    return ProductData(
      name: name ?? this.name,
      productAlert: productAlert ?? this.productAlert,
      priority: priority ?? this.priority,
      quantity: quantity ?? this.quantity,
      productCount: productCount ?? this.productCount,
      images: images ?? this.images,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      id: id ?? this.id,
      isActive: isActive ?? this.isActive,
      newPrice: newPrice ?? this.newPrice,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      subWarehouseId: subWarehouseId ?? this.subWarehouseId,
      maxCount: maxCount ?? this.maxCount,
    );
  }

  factory ProductData.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return ProductData(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      unit: json['unit'] ?? 'null',
      categoryId: json['category_id'].toString(),
      price: json['price'].toString(),
      isActive: json['is_active'].toString(),
      quantity: json['quantity'].toString(),
      productCount: StoreProvider.of<AppState>(navigatorKey.currentContext)
          .state
          .cartState
          .cartProducts
          .firstWhere((product) => product.id == json['id'], orElse: () => ProductData(productCount: 0))
          .productCount,
      images: List<ProductImage>.from(json['images'].map((x) => ProductImage.fromJson(x))),
      priority: json['priority'],
      productAlert: json['alert_product'] == null ? null : ProductAlert.fromJson(json['alert_product']),
      subWarehouseId: json['sub_warehouse_id'],
      newPrice: json['new_price'],
      alertId: json['alert_id'].toString(),
      maxCount: json['max_quantity'] == null ? '0' : json['max_quantity'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'unit': unit,
        'category_id': categoryId,
        'price': price,
        'is_active': isActive,
        'quantity': quantity,
        'productCount': productCount,
        'images': List<dynamic>.from(images.map((x) => x.toJson())),
      };
}

class ProductImage {
  ProductImage({this.id, this.productId, this.imageFileName});

  int id;
  String productId;
  String imageFileName;

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
        id: json['id'],
        productId: json['product_id'].toString(),
        imageFileName: json['image_file_name'],
      );

  Map<String, dynamic> toJson() => {'id': id, 'product_id': productId, 'image_file_name': imageFileName};
}
