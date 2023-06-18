import '../../../../core/core_importer.dart';
import '../../../products/domain/entities/product_entity.dart';
import 'inventory_action.dart';
import 'inventory_state.dart';

Reducer<InventoryState> inventoryReducer = combineReducers<InventoryState>([
  TypedReducer<InventoryState, SetSearchFilter>(setSearchFilter),
  TypedReducer<InventoryState, EndOfInventory>(endOfProducts),
  TypedReducer<InventoryState, NextPage>(nextPage),
  TypedReducer<InventoryState, ClearInventory>(clearInventory),
  TypedReducer<InventoryState, SetInventoryProducts>(setInventoryProducts),
  TypedReducer<InventoryState, SetInventoryType>(setInventoryType),
  TypedReducer<InventoryState, SetInventorySubWarehouseId>(setSubWarehouseId),
  TypedReducer<InventoryState, SetIsActive>(setIsActive),
  TypedReducer<InventoryState, SetIAllProducts>(setIAllProducts),
  TypedReducer<InventoryState, ChangeSubWarehouseFilter>(changeSubWarehouseFilter),
  TypedReducer<InventoryState, SetNotAddedProducts>(setNotAddedProducts),
  TypedReducer<InventoryState, SetSubWarehouseFilter>(setSubWarehouseFilter),
]);

InventoryState setInventoryProducts(InventoryState state, SetInventoryProducts action) {
  List<ProductEntity> products = [];
  products.addAll(state.products);
  products.addAll(action.products);

  return state.copyWith(products: products);
}

InventoryState setSearchFilter(InventoryState state, SetSearchFilter action) =>
    state.copyWith(searchFilter: action.searchFilter);

InventoryState setIAllProducts(InventoryState state, SetIAllProducts action) =>
    state.copyWith(allProducts: action.products);

InventoryState setNotAddedProducts(InventoryState state, SetNotAddedProducts action) =>
    state.copyWith(notAddedProducts: action.products);

InventoryState setInventoryType(InventoryState state, SetInventoryType action) {
  return state.copyWith(inventoryType: action.inventoryType);
}

InventoryState changeSubWarehouseFilter(InventoryState state, ChangeSubWarehouseFilter action) {
  int filter = state.subWarehouseFilter;
  List<ProductEntity> products = state.products;
  switch (filter) {
    case 0:
      products.sort((a, b) {
        if (int.parse(a.isActive) == 0) {
          return -1;
        } else {
          return 1;
        }
      });
      filter = 1;
      snackBar(success: true, message: 'فرز حسب المواد الغير مفعلة', context: action.context);
      break;
    case 1:
      products.sort((a, b) {
        if (int.parse(a.isActive) == 0) {
          return 1;
        } else {
          return -1;
        }
      });
      filter = 2;
      snackBar(success: true, message: 'فرز حسب المواد  المفعلة', context: action.context);
      break;
    case 2:
      products.sort((a, b) {
        if (a.id > b.id) {
          return -1;
        } else if (a.id < b.id) {
          return 1;
        } else {
          return 0;
        }
      });
      filter = 0;
      snackBar(success: true, message: 'فرز حسب المواد المضافة حديثاً', context: action.context);
      break;
  }
  return state.copyWith(products: products, subWarehouseFilter: filter);
}

InventoryState setSubWarehouseId(InventoryState state, SetInventorySubWarehouseId action) =>
    state.copyWith(subWarehouseId: action.subWarehouseId);

InventoryState setIsActive(InventoryState state, SetIsActive action) => state.copyWith(isActive: action.isActive);

InventoryState endOfProducts(InventoryState state, EndOfInventory action) => state.copyWith(hasNext: false);

InventoryState nextPage(InventoryState state, NextPage action) => state.copyWith(pageNumber: state.pageNumber + 1);

InventoryState clearInventory(InventoryState state, ClearInventory action) =>
    state.copyWith(products: [], pageNumber: 1, hasNext: true);

InventoryState setSubWarehouseFilter(InventoryState state, SetSubWarehouseFilter action) =>
    state.copyWith(subWarehouseFilter: action.filter);
