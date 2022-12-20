import '../../../../core/core_importer.dart';
import 'inventory_action.dart';
import 'inventory_state.dart';

Reducer<InventoryState> inventoryReducer = combineReducers<InventoryState>([
  TypedReducer<InventoryState, SetSearchFilter>(setSearchFilter),
  TypedReducer<InventoryState, EndOfProducts>(endOfProducts),
  TypedReducer<InventoryState, NextPage>(nextPage),
  TypedReducer<InventoryState, ClearInventory>(clearInventory),
  TypedReducer<InventoryState, SetInventoryProducts>(setInventoryProducts),
  TypedReducer<InventoryState, SetInventoryType>(setInventoryType),
  TypedReducer<InventoryState, SetSubWarehouseId>(setSubWarehouseId),
  TypedReducer<InventoryState, SetIsActive>(setIsActive),
]);

InventoryState setInventoryProducts(InventoryState state, SetInventoryProducts action) {
  List<ProductData> products = [];
  products.addAll(state.products);
  products.addAll(action.products);
  return state.copyWith(products: products);
}

InventoryState setSearchFilter(InventoryState state, SetSearchFilter action) =>
    state.copyWith(searchFilter: action.searchFilter);

InventoryState setInventoryType(InventoryState state, SetInventoryType action) {
  Tools.logToConsole('red');
  Tools.logToConsole(action.inventoryType);
  return state.copyWith(inventoryType: action.inventoryType);
}

InventoryState setSubWarehouseId(InventoryState state, SetSubWarehouseId action) =>
    state.copyWith(subWarehouseId: action.subWarehouseId);

InventoryState setIsActive(InventoryState state, SetIsActive action) => state.copyWith(isActive: action.isActive);

InventoryState endOfProducts(InventoryState state, EndOfProducts action) => state.copyWith(hasNext: false);

InventoryState nextPage(InventoryState state, NextPage action) => state.copyWith(pageNumber: state.pageNumber + 1);

InventoryState clearInventory(InventoryState state, ClearInventory action) =>
    state.copyWith(products: [], pageNumber: 1, hasNext: true);
