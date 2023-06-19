import '../../../../core/core_importer.dart';
import 'sub_warehouse_manager_action.dart';
import 'sub_warehouse_manager_state.dart';

Reducer<SubWarehouseManagerState> subWarehouseManagerReducer = combineReducers<SubWarehouseManagerState>([
  TypedReducer<SubWarehouseManagerState, SetFile>(setFile),
  TypedReducer<SubWarehouseManagerState, SetSubWarehouseId>(setSubWarehouse),
]);
SubWarehouseManagerState setFile(SubWarehouseManagerState state, SetFile action) => state.copyWith(file: action.file);

SubWarehouseManagerState setSubWarehouse(SubWarehouseManagerState state, SetSubWarehouseId action) =>
    state.copyWith(subWarehouseId: action.subWarehouseId);
