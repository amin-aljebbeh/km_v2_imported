import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../../../inventory/model/inventory_model_importer.dart';
import 'inventory_action.dart';

Future<void> inventoryMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is GetNotificationProducts) {
    store.dispatch(StartLoading());
    Either either = await store.state.inventoryState.inventoryUseCase
        .getNotificationProductsUseCase(pageNumber: store.state.inventoryState.pageNumber);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')), (products) {
      FilteredProductsModel filteredProductsModel = products;
      store.dispatch(SetInventoryProducts(products: filteredProductsModel.data.products));
      if (filteredProductsModel.data.nextPageUrl == null) store.dispatch(EndOfProducts());
    });
    store.dispatch(StopLoading());
  }
  next(action);
}
