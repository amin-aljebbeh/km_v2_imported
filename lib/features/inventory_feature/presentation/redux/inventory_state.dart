import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

import '../../../../core/core_importer.dart';
import '../../domain/use_cases/inventory_use_cases.dart';

@immutable
class InventoryState extends Equatable {
  final List<ProductEntity> products;
  final InventoryUseCase inventoryUseCase;
  final String searchFilter;
  final int pageNumber;
  final bool hasNext;
  final int subWarehouseId;
  final int isActive;
  final InventoryTypes inventoryType;
  const InventoryState({
    this.subWarehouseId,
    this.isActive,
    this.products,
    this.inventoryUseCase,
    this.searchFilter,
    this.pageNumber,
    this.hasNext,
    this.inventoryType,
  });

  factory InventoryState.initial() {
    return InventoryState(
      products: const [],
      inventoryUseCase: sl<InventoryUseCase>(),
      searchFilter: '',
      pageNumber: 1,
      isActive: 0,
      subWarehouseId: null,
      hasNext: true,
      inventoryType: null,
    );
  }

  InventoryState copyWith({
    List<ProductEntity> products,
    String searchFilter,
    int pageNumber,
    bool hasNext,
    InventoryTypes inventoryType,
    int subWarehouseId,
    int isActive,
  }) {
    return InventoryState(
      inventoryUseCase: inventoryUseCase,
      products: products ?? this.products,
      searchFilter: searchFilter ?? this.searchFilter,
      hasNext: hasNext ?? this.hasNext,
      inventoryType: inventoryType ?? this.inventoryType,
      pageNumber: pageNumber ?? this.pageNumber,
      subWarehouseId: subWarehouseId == -1 ? null : subWarehouseId ?? this.subWarehouseId,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object> get props =>
      [inventoryUseCase, products, searchFilter, hasNext, pageNumber, inventoryType, subWarehouseId, isActive];
}
