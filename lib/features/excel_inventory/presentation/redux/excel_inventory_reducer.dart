import '../../../../core/core_importer.dart';
import 'excel_inventory_action.dart';
import 'excel_inventory_state.dart';

Reducer<ExcelInventoryState> excelInventoryReducer = combineReducers<ExcelInventoryState>([
  TypedReducer<ExcelInventoryState, SetFile>(setFile),
  TypedReducer<ExcelInventoryState, SetSubWarehouseId>(setSubWarehouse),
]);
ExcelInventoryState setFile(ExcelInventoryState state, SetFile action) => state.copyWith(file: action.file);

ExcelInventoryState setSubWarehouse(ExcelInventoryState state, SetSubWarehouseId action) =>
    state.copyWith(subWarehouseId: action.subWarehouseId);

