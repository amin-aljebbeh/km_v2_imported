import 'package:kammun_app/features/categories/domain/entities/category_entity.dart';
import 'package:kammun_app/features/products/domain/entities/barcode_entity.dart';
import 'package:kammun_app/features/products/domain/entities/order_product_pivot_entity.dart';
import 'package:kammun_app/features/products/domain/entities/product_image_entity.dart';
import 'package:kammun_app/features/warehouses/domain/entities/warehouse_entity.dart';

class ProductEntity {
  final int id;
  final String name;
  final String description;
  final String unit;
  final String quantity;
  final String isActive;
  final List<ProductImageEntity> images;
  final String supplierCode;
  final int subWarehouseId;
  final String availableQuantity;
  final int isPrimeItem;
  final OrderProductPivotEntity pivot;
  final String categoryId;
  final String price;
  final int productCount;
  final List<CategoryEntity> categories;
  final List<WarehouseEntity> warehouses;
  final int warehouseId;
  final int isFeatured;
  final int priority;
  final int numberOfVisits;
  final double minThreshold;
  final int increasePercentage;
  final String priceFactor;
  final int underCheckAvailability;
  final String priceChange;
  final int automaticActivation;
  final int rate;
  final int numberOfSales;
  final List<BarcodeEntity> barcodes;
  final int deleteTimes;
  final String alertProductsCount;

  ProductEntity({
    this.id,
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
    this.categoryId,
    this.price,
    this.productCount,
    this.categories,
    this.warehouses,
    this.warehouseId,
    this.isFeatured,
    this.priority,
    this.numberOfVisits,
    this.minThreshold,
    this.increasePercentage,
    this.priceFactor,
    this.underCheckAvailability,
    this.priceChange,
    this.automaticActivation,
    this.rate,
    this.numberOfSales,
    this.barcodes,
    this.deleteTimes,
    this.alertProductsCount,
  });
}
