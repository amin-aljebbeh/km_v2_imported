import 'package:kammun_app/features/barcode/data/models/barcode_model.dart';
import 'package:kammun_app/features/general_information/data/models/category_model.dart';
import 'package:kammun_app/features/general_information/data/models/warehouse_model.dart';
import 'package:kammun_app/features/products/data/models/order_product_pivot_model.dart';
import 'package:kammun_app/features/products/data/models/product_image_model.dart';
import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    String name,
    String description,
    String unit,
    String quantity,
    String isActive,
    List<ProductImageModel> images,
    String supplierCode,
    int subWarehouseId,
    String availableQuantity,
    int isPrimeItem,
    pivot,
    String price,
    int productCount,
    List<CategoryModel> categories,
    List<WarehouseModel> warehouses,
    int isFeatured,
    int priority,
    purchasePrice,
    double minThreshold,
    int increasePercentage,
    String priceFactor,
    String priceChange,
    int automaticActivation,
    int rate,
    List<BarcodeModel> barcodes,
    int deleteTimes,
    int productId,
    String alertProductsCount,
  }) : super(
          productId: productId,
          name: name,
          description: description,
          unit: unit,
          quantity: quantity,
          isActive: isActive,
          images: images,
          supplierCode: supplierCode,
          subWarehouseId: subWarehouseId,
          availableQuantity: availableQuantity,
          isPrimeItem: isPrimeItem,
          pivot: pivot,
          price: price,
          productCount: productCount,
          categories: categories,
          warehouses: warehouses,
          isFeatured: isFeatured,
          priority: priority,
          purchasePrice: purchasePrice,
          minThreshold: minThreshold,
          increasePercentage: increasePercentage,
          priceFactor: priceFactor,
          priceChange: priceChange,
          automaticActivation: automaticActivation,
          rate: rate,
          barcodes: barcodes,
          deleteTimes: deleteTimes,
          alertProductsCount: alertProductsCount,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        purchasePrice: json['purchase_price'].toString(),
        productId: json['product_id'] ?? json['id'] ?? 0,
        name: json['name'] ?? json['nameProduct'],
        description: json['description'],
        unit: json['unit'].toString(),
        price: json['price'] != null ? json['price'].toString() : '0',
        priceChange: json['price_change'] == null ? '0' : json['price_change'].toString(),
        isActive: json['is_active'] != null ? json['is_active'].toString() : '0',
        quantity: json['quantity'] == null ? '0' : json['quantity'].toString(),
        productCount: json['productCount'] ?? 0,
        supplierCode:
            json['supplier_code'] == null ? json['supplierCode'].toString() : json['supplier_code'].toString(),
        subWarehouseId: json['sub_warehouse_id'] ?? -1,
        isFeatured: json['is_featured'],
        priority: json['priority'],
        isPrimeItem: json['is_prime_item'],
        minThreshold: json['min_threshold']?.toDouble(),
        increasePercentage: json['increase_percentage'] ?? 0,
        priceFactor: json['price_factor'],
        alertProductsCount: json['alert_products_count'].toString(),
        automaticActivation: json['automatic_activation'],
        images: json['images'] == null
            ? []
            : List<ProductImageModel>.from(json['images'].map((x) => ProductImageModel.fromJson(x))),
        categories: json['categories'] == null
            ? []
            : List<CategoryModel>.from(json['categories'].map((x) => CategoryModel.fromJson(x))),
        warehouses: json['warehouses'] == null
            ? []
            : List<WarehouseModel>.from(json['warehouses'].map((x) => WarehouseModel.fromJson(x))),
        rate: json['rate'] ?? -1,
        barcodes: json['barcodes'] == null
            ? []
            : List<BarcodeModel>.from(json['barcodes'].map((x) => BarcodeModel.fromJson(x))),
        deleteTimes: json['count_deleted'] ?? -1,
        availableQuantity: json['available_quantity'] == null ? 'null' : json['available_quantity'].toString(),
        pivot: json['pivot'] == null ? null : OrderProductPivotModel.fromJson(json['pivot']),
      );
}
