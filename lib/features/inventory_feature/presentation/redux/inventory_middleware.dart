import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../../../inventory/model/inventory_model_importer.dart';
import 'inventory_action.dart';

Future<void> inventoryMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is GetInventory) {
    store.dispatch(StartLoading());
    switch (store.state.inventoryState.inventoryType) {
      case InventoryTypes.notification:
        Tools.logToConsole('message');
        Tools.logToConsole('aa');
        store.dispatch(GetNotificationProductsAction());
        break;
      case InventoryTypes.prime:
        Tools.logToConsole('message');
        Tools.logToConsole('bb');
        store.dispatch(GetPrimeProductsAction());
        break;
    }
  } else if (action is GetNotificationProductsAction) {
    Either either = await store.state.inventoryState.inventoryUseCase
        .getNotificationProductsUseCase(pageNumber: store.state.inventoryState.pageNumber);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')), (products) {
      FilteredProductsModel filteredProductsModel = products;
      store.dispatch(SetInventoryProducts(products: filteredProductsModel.data.products));
      if (filteredProductsModel.data.nextPageUrl == null) store.dispatch(EndOfProducts());
    });
    store.dispatch(StopLoading());
  } else if (action is GetPrimeProductsAction) {
    Either either = await store.state.inventoryState.inventoryUseCase.getPrimeProductsUseCase(
        pageNumber: store.state.inventoryState.pageNumber,
        isActive: store.state.inventoryState.isActive,
        subWarehouseId: store.state.inventoryState.subWarehouseId);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')), (products) {
      FilteredProductsModel filteredProductsModel = products;
      store.dispatch(SetInventoryProducts(products: filteredProductsModel.data.products));
      if (filteredProductsModel.data.nextPageUrl == null) store.dispatch(EndOfProducts());
    });
    store.dispatch(StopLoading());
  }
  next(action);
}
