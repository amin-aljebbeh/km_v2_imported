import '../../../../core/core_importer.dart';
import 'inventory_file_action.dart';
import 'inventory_file_state.dart';

Reducer<InventoryFileState> inventoryFileReducer = combineReducers<InventoryFileState>([
  TypedReducer<InventoryFileState, SetInventoryFileProduct>(setInventoryFileProduct),
  TypedReducer<InventoryFileState, SetProductsSent>(setProductsSent),
  TypedReducer<InventoryFileState, SetProductsSelected>(setProductsSelected),
  TypedReducer<InventoryFileState, InventoryLoading>(inventoryLoading),
  TypedReducer<InventoryFileState, InventoryError>(inventoryError),
  TypedReducer<InventoryFileState, InitInventoryFile>(initInventoryFile),
]);

InventoryFileState initInventoryFile(InventoryFileState state, InitInventoryFile action) =>
    InventoryFileState.initial();

InventoryFileState setInventoryFileProduct(InventoryFileState state, SetInventoryFileProduct action) =>
    state.copyWith(inventoryFileProductEntity: action.inventoryFileProductEntity);

InventoryFileState setProductsSent(InventoryFileState state, SetProductsSent action) =>
    state.copyWith(productsSent: action.sent);

InventoryFileState setProductsSelected(InventoryFileState state, SetProductsSelected action) =>
    state.copyWith(productsSelected: action.selected);

InventoryFileState inventoryLoading(InventoryFileState state, InventoryLoading action) =>
    state.copyWith(loading: action.loading);

InventoryFileState inventoryError(InventoryFileState state, InventoryError action) =>
    state.copyWith(error: action.error);
