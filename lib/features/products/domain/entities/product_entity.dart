import 'package:kammun_app/features/barcode/domain/entities/barcode_entity.dart';
import 'package:kammun_app/features/general_information/domain/entities/category_entity.dart';
import 'package:kammun_app/features/general_information/domain/entities/warehouse_entity.dart';
import 'package:kammun_app/features/products/domain/entities/order_product_pivot_entity.dart';
import 'package:kammun_app/features/products/domain/entities/product_image_entity.dart';

class ProductEntity {
  final int productId;
  String name;
  String description;
  String unit;
  String quantity;
  String isActive;
  final List<ProductImageEntity> images;
  String supplierCode;
  int subWarehouseId;
  final String availableQuantity;
  int isPrimeItem;
  OrderProductPivotEntity pivot;
  String price;
  int productCount;
  final List<CategoryEntity> categories;
  final List<WarehouseEntity> warehouses;
  int isFeatured;
  int priority;
  final double minThreshold;
  int increasePercentage;
  String priceFactor;
  final String priceChange;
  final int automaticActivation;
  final int rate;
  final List<BarcodeEntity> barcodes;
  final int deleteTimes;
  final int discountValue;

  final String alertProductsCount;

  final String purchasePrice;

  ProductEntity({
    this.productId,
    this.discountValue,
    this.name,
    this.description,
    this.unit,
    this.quantity,
    this.isActive,
    this.images,
    this.supplierCode,
    this.subWarehouseId,
    this.availableQuantity,
    this.isPrimeItem,
    this.pivot,
    this.price,
    this.productCount,
    this.categories,
    this.warehouses,
    this.isFeatured,
    this.priority,
    this.minThreshold,
    this.increasePercentage,
    this.priceFactor,
    this.priceChange,
    this.automaticActivation,
    this.rate,
    this.barcodes,
    this.deleteTimes,
    this.alertProductsCount,
    this.purchasePrice,
  });
}
