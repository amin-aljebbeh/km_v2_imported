import '../../../../core/core_importer.dart';
import '../../domain/use_cases/inventory_use_cases.dart';

@immutable
class InventoryState extends Equatable {
  final List<ProductData> products;
  final InventoryUseCase inventoryUseCase;
  final String searchFilter;
  final int pageNumber;
  final bool hasNext;
  const InventoryState({this.products, this.inventoryUseCase, this.searchFilter, this.pageNumber, this.hasNext});

  factory InventoryState.initial() {
    return InventoryState(
        products: const [], inventoryUseCase: sl<InventoryUseCase>(), searchFilter: '', pageNumber: 1, hasNext: true);
  }

  InventoryState copyWith({List<ProductData> products, String searchFilter, int pageNumber, bool hasNext}) {
    return InventoryState(
        inventoryUseCase: inventoryUseCase,
        products: products ?? this.products,
        searchFilter: searchFilter ?? this.searchFilter,
        hasNext: hasNext ?? this.hasNext,
        pageNumber: pageNumber ?? this.pageNumber);
  }

  @override
  List<Object> get props => [inventoryUseCase, products, searchFilter, hasNext, pageNumber];
}
