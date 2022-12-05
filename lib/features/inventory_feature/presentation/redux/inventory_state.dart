import '../../../../core/core_importer.dart';
import '../../domain/repositories/inventory_repository.dart';

@immutable
class InventoryState extends Equatable {
  final List<ProductData> products;
  final InventoryRepository inventoryRepository;
  final String searchFilter;
  final int pageNumber;
  final bool hasNext;
  const InventoryState({this.products, this.inventoryRepository, this.searchFilter, this.pageNumber, this.hasNext});

  factory InventoryState.initial() {
    return InventoryState(
        products: const [],
        inventoryRepository: sl<InventoryRepository>(),
        searchFilter: '',
        pageNumber: 1,
        hasNext: true);
  }

  InventoryState copyWith({List<ProductData> products, String searchFilter, int pageNumber, bool hasNext}) {
    return InventoryState(
        inventoryRepository: inventoryRepository,
        products: products ?? this.products,
        searchFilter: searchFilter ?? this.searchFilter,
        hasNext: hasNext ?? this.hasNext,
        pageNumber: pageNumber ?? this.pageNumber);
  }

  @override
  List<Object> get props => [inventoryRepository, products, searchFilter, hasNext, pageNumber];
}
