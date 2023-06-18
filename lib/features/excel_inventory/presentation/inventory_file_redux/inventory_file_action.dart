import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/inventory_file_product_entity.dart';
import '../redux/excel_inventory_state.dart';

abstract class InventoryFileAction {
  handle({@required Store<AppState> store, ExcelInventoryState state});
}

class ImportProductActivationInWarehouseAction extends InventoryFileAction {
  @override
  handle({Store<AppState> store, ExcelInventoryState state}) async {
    store.dispatch(InventoryLoading(loading: true));
    store.dispatch(SetProductsSent(sent: true));
    Either either = await state.excelInventoryUseCases
        .importProductActivationInWarehouseUseCase(file: state.file, subWarehouseId: state.subWarehouseId.toString());
    either.fold((failure) => store.dispatch(InventoryError(error: true)), (response) {
      InventoryFileProductEntity products = response;
      store.dispatch(SetInventoryFileProduct(inventoryFileProductEntity: products));
    });
    store.dispatch(InventoryLoading(loading: false));
  }
}

class SetInventoryFileProduct {
  final InventoryFileProductEntity inventoryFileProductEntity;

  SetInventoryFileProduct({this.inventoryFileProductEntity});
}

class InitInventoryFile {}

class SetProductsSent {
  final bool sent;

  SetProductsSent({this.sent});
}

class SetProductsSelected {
  final int selected;

  SetProductsSelected({this.selected});
}

class InventoryLoading {
  final bool loading;

  InventoryLoading({this.loading});
}

class InventoryError {
  final bool error;

  InventoryError({this.error});
}
