import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../inventory_file_redux/inventory_file_action.dart';
import '../pages/excel_inventory_page.dart';
import '../price_file_redux/price_file_action.dart';
import 'sub_warehouse_manager_state.dart';

abstract class SubWarehouseManagerAction {
  handle({@required Store<AppState> store, SubWarehouseManagerState state});
}

class InitExcelInventory extends SubWarehouseManagerAction {
  final int subWarehouseId;

  InitExcelInventory({this.subWarehouseId = -1});

  @override
  handle({Store<AppState> store, SubWarehouseManagerState state}) {
    store.dispatch(SetSubWarehouseId(subWarehouseId: subWarehouseId));
    store.dispatch(InitInventoryFile());
    store.dispatch(InitPriceFile());
  }
}

class UpdatePriceRateThresholdAction extends SubWarehouseManagerAction {
  final String threshold;
  final BuildContext context;

  UpdatePriceRateThresholdAction({this.threshold, this.context});

  @override
  handle({Store<AppState> store, SubWarehouseManagerState state}) async {
    store.dispatch(StartLoading());
    Either either = await state.subWarehouseManagerUseCases.updatePriceRateThresholdUseCase(threshold: threshold);
    either.fold(
        (failure) => snackBar(success: false, message: 'فشلت عملية التعديل يرجى المحاولة مجدداً', context: context),
        (_) => snackBar(success: true, message: 'تم التعديل بنجاح', context: context));
    store.dispatch(StopLoading());
  }
}

class PickFileAction extends SubWarehouseManagerAction {
  final BuildContext context;

  PickFileAction({this.context});

  @override
  handle({Store<AppState> store, SubWarehouseManagerState state}) async {
    Either either = await state.subWarehouseManagerUseCases.pickFileUseCase();
    either.fold((_) {}, (file) {
      if (file != null) {
        store.dispatch(SetFile(file: file));
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ExcelInventoryPage()));
      }
    });
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
