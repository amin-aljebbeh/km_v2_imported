import '../../../../core/core_importer.dart';
import '../inventory_file_redux/inventory_file_action.dart';
import '../price_file_redux/price_file_action.dart';
import 'excel_inventory_state.dart';

abstract class ExcelInventoryAction {
  handle({@required Store<AppState> store, ExcelInventoryState state});
}

class InitExcelInventory extends ExcelInventoryAction {
  final int subWarehouseId;

  InitExcelInventory({this.subWarehouseId = -1});

  @override
  handle({Store<AppState> store, ExcelInventoryState state}) {
    store.dispatch(SetSubWarehouseId(subWarehouseId: subWarehouseId));
    store.dispatch(InitInventoryFile());
    store.dispatch(InitPriceFile());
  }
}

class SetFile {
  final File file;

  SetFile({this.file});
}

class SetSubWarehouseId {
  final int subWarehouseId;

  SetSubWarehouseId({this.subWarehouseId});
}
