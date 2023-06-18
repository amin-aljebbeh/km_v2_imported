import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/price_file_product_entity.dart';
import '../redux/excel_inventory_state.dart';

abstract class PriceFileAction {
  handle({@required Store<AppState> store, ExcelInventoryState state});
}

class ImportProductPricesInWarehouseAction extends PriceFileAction {
  @override
  handle({Store<AppState> store, ExcelInventoryState state}) async {
    store.dispatch(PriceLoading(loading: true));
    store.dispatch(SetPriceSent(sent: true));
    Either either = await state.excelInventoryUseCases
        .importProductPricesInWarehouseUseCase(file: state.file, subWarehouseId: state.subWarehouseId.toString());
    either.fold((failure) => store.dispatch(PriceError(error: true)), (response) {
      PriceFileProductEntity products = response;
      store.dispatch(SetPriceFileProduct(priceFileProductEntity: products));
    });
    store.dispatch(PriceLoading(loading: false));
  }
}

class InitPriceFile {}

class SetPriceFileProduct {
  final PriceFileProductEntity priceFileProductEntity;

  SetPriceFileProduct({this.priceFileProductEntity});
}

class SetPriceSent {
  final bool sent;

  SetPriceSent({this.sent});
}

class SetPriceSelected {
  final int selected;

  SetPriceSelected({this.selected});
}

class PriceLoading {
  final bool loading;

  PriceLoading({this.loading});
}

class PriceError {
  final bool error;

  PriceError({this.error});
}
