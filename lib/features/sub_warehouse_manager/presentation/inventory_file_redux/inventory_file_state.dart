import '../../../../core/core_importer.dart';
import '../../domain/entities/inventory_file_product_entity.dart';

@immutable
class InventoryFileState extends Equatable {
  final InventoryFileProductEntity inventoryFileProductEntity;
  final bool productsSent;
  final int productsSelected;
  final bool loading;
  final bool error;

  const InventoryFileState(
      {this.loading, this.error, this.inventoryFileProductEntity, this.productsSent, this.productsSelected});

  factory InventoryFileState.initial() {
    return InventoryFileState(
      productsSelected: 0,
      productsSent: false,
      loading: false,
      error: false,
      inventoryFileProductEntity: InventoryFileProductEntity(
          nonIntroducedProducts: [], toDeActiveList: [], toActiveList: [], activatedList: []),
    );
  }

  InventoryFileState copyWith({
    InventoryFileProductEntity inventoryFileProductEntity,
    bool productsSent,
    int productsSelected,
    bool loading,
    bool error,
  }) {
    return InventoryFileState(
      productsSelected: productsSelected ?? this.productsSelected,
      inventoryFileProductEntity: inventoryFileProductEntity ?? this.inventoryFileProductEntity,
      productsSent: productsSent ?? this.productsSent,
      error: error ?? this.error,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object> get props => [productsSelected, inventoryFileProductEntity, productsSent, error, loading];
}
