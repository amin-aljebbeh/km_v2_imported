import 'package:kammun_app/models/models_importer.dart';

import '../core/core_importer.dart';

CategoryProduct categoryProductFromJson(String str) => CategoryProduct.fromJson(json.decode(str));

List<ProductData> syncCartFromJson(String str) =>
    List<ProductData>.from(json.decode(str).map((x) => ProductData.fromJson(x)));

// CategoryProduct publicParameterFromJson(String str) =>
//     CategoryProduct.fromJson(json.decode(str));

class CategoryProduct {
  CategoryProduct({
    this.success,
    this.data,
  });

  bool success;
  ProductResponse data;

  factory CategoryProduct.fromJson(Map<String, dynamic> json) => CategoryProduct(
        success: json['success'],
        data: ProductResponse.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data.toJson(),
      };
}

class ProductResponse {
  ProductResponse({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int currentPage;
  List<ProductData> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  factory ProductResponse.fromJson(Map<String, dynamic> json) => ProductResponse(
        currentPage: json['current_page'],
        data: List<ProductData>.from(json['data'].map((x) => x == null ? null : ProductData.fromJson(x))),
        firstPageUrl: json['first_page_url'],
        from: json['from'],
        lastPage: json['last_page'],
        lastPageUrl: json['last_page_url'],
        nextPageUrl: json['next_page_url'],
        path: json['path'],
        perPage: json['per_page'],
        prevPageUrl: json['prev_page_url'],
        to: json['to'],
        total: json['total'],
      );

  Map<String, dynamic> toJson() => {
        'current_page': currentPage,
        'data': List<dynamic>.from(data.map((x) => x?.toJson())),
        'first_page_url': firstPageUrl,
        'from': from,
        'last_page': lastPage,
        'last_page_url': lastPageUrl,
        'next_page_url': nextPageUrl,
        'path': path,
        'per_page': perPage,
        'prev_page_url': prevPageUrl,
        'to': to,
        'total': total,
      };
}

class ProductData {
  ProductData({
    this.id,
    this.name,
    this.description,
    this.unit,
    this.price,
    this.isActive,
    this.quantity,
    this.productCount,
    this.images,
    this.supplierCode,
    this.warehouseId,
    this.isFeatured,
    this.underCheckAvailability,
    this.priceFactor,
    this.increasePercentage,
    this.minThreshold,
    this.numberOfVisits,
    this.priority,
    this.subWarehouseId,
    this.priceChange,
    this.categories,
    this.warehouses,
    this.automaticActivation,
    this.rate,
    this.numberOfSales,
    this.barcodes,
    this.deleteTimes,
    this.availableQuantity,
    this.pivot,
    this.alertProductsCount,
  });

  int id;
  String name;
  String description;
  String unit;
  String price;
  String isActive;
  String quantity;
  int productCount;
  List<ProductImage> images;
  String supplierCode;
  List<CategoryOriginalData> categories;
  List<Warehouse> warehouses;

  //////

  int warehouseId;
  int isFeatured;
  int priority;
  int numberOfVisits;
  double minThreshold;
  int increasePercentage;
  String priceFactor;
  int underCheckAvailability;
  int subWarehouseId;
  String priceChange;
  int automaticActivation;
  int rate;
  int numberOfSales;
  List<Barcode> barcodes;
  int deleteTimes;
  String availableQuantity;
  OrderProductPivot pivot;
  String alertProductsCount;

  factory ProductData.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    ProductData productData = ProductData(
      id: json['id'] ?? json['product_id'] ?? 0,
      name: json['name'] ?? json['nameProduct'],
      description: json['description'],
      unit: json['unit'].toString(),
      price: json['price'] != null ? json['price'].toString() : '0',
      priceChange: json['price_change'] == null ? '0' : json['price_change'].toString(),
      isActive: json['is_active'] != null ? json['is_active'].toString() : '0',
      quantity: json['quantity'] == null ? '0' : json['quantity'].toString(),
      productCount: json['productCount'] ?? 0,
      supplierCode: json['supplier_code'] == null ? json['supplierCode'].toString() : json['supplier_code'].toString(),
      warehouseId: json['warehouse_id'],
      subWarehouseId: json['sub_warehouse_id'] ?? -1,
      isFeatured: json['is_featured'],
      priority: json['priority'],
      numberOfVisits: json['number_of_visits'],
      minThreshold: json['min_threshold']?.toDouble(),
      increasePercentage: json['increase_percentage'] ?? 0,
      priceFactor: json['price_factor'],
      alertProductsCount: json['alert_products_count'].toString(),
      automaticActivation: json['automatic_activation'],
      underCheckAvailability: json['under_check_availability'],
      images:
          json['images'] == null ? [] : List<ProductImage>.from(json['images'].map((x) => ProductImage.fromJson(x))),
      categories: json['categories'] == null
          ? []
          : List<CategoryOriginalData>.from(json['categories'].map((x) => CategoryOriginalData.fromJson(x))),
      warehouses:
          json['warehouses'] == null ? [] : List<Warehouse>.from(json['warehouses'].map((x) => Warehouse.fromJson(x))),
      rate: json['rate'] ?? -1,
      numberOfSales: json['number_of_sale'],
      barcodes: json['barcodes'] == null ? [] : List<Barcode>.from(json['barcodes'].map((x) => Barcode.fromJson(x))),
      deleteTimes: json['count_deleted'] ?? -1,
      availableQuantity: json['available_quantity'] == null ? 'null' : json['available_quantity'].toString(),
      pivot: json['pivot'] == null ? null : OrderProductPivot.fromJson(json['pivot']),
    );
    return productData;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'unit': unit,
        'price': price,
        'is_active': isActive,
        'quantity': quantity,
        'productCount': productCount,
        'sub_warehouse_id': subWarehouseId,
        'supplier_code': supplierCode,
        'price_change': priceChange,
        'images': List<dynamic>.from(images.map((x) => x.toJson())),
      };
}
