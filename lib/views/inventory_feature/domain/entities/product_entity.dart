import 'package:kammun_app/core/core_importer.dart';

class ProductEntity extends Equatable {
  final int id;
  final String name;
  final String description;
  final String unit;
  final String price;
  final String isActive;
  final String quantity;
  final int productCount;
  final List<ProductImage> images;
  final String supplierCode;
  final List<CategoryOriginalData> categories;
  final List<Warehouse> warehouses;
  final int warehouseId;
  final int isFeatured;
  final int priority;
  final int numberOfVisits;
  final double minThreshold;
  final int increasePercentage;
  final String priceFactor;
  final int underCheckAvailability;
  final int subWarehouseId;
  final String priceChange;
  final int automaticActivation;
  final int rate;
  final int numberOfSales;
  final List<Barcode> barcodes;
  final int deleteTimes;
  final String availableQuantity;
  final OrderProductPivot pivot;
  final String alertProductsCount;

  const ProductEntity({
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
    this.subWarehouseId,
    this.priceChange,
    this.automaticActivation,
    this.rate,
    this.numberOfSales,
    this.barcodes,
    this.deleteTimes,
    this.availableQuantity,
    this.pivot,
    this.alertProductsCount,
  });

  @override
  List<Object> get props => [
        id,
        name,
        description,
        unit,
        price,
        isActive,
        quantity,
        productCount,
        images,
        supplierCode,
        categories,
        warehouses,
        warehouseId,
        isFeatured,
        priority,
        numberOfVisits,
        minThreshold,
        increasePercentage,
        priceFactor,
        underCheckAvailability,
        subWarehouseId,
        priceChange,
        automaticActivation,
        rate,
        numberOfSales,
        barcodes,
        deleteTimes,
        availableQuantity,
        pivot,
        alertProductsCount,
      ];
}
