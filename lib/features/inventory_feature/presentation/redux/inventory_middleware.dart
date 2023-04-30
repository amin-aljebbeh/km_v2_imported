import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../../../inventory/model/inventory_model_importer.dart';
import 'inventory_action.dart';

Future<void> inventoryMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is GetInventory) {
    switch (store.state.inventoryState.inventoryType) {
      case InventoryTypes.notification:
        store.dispatch(GetNotificationProductsAction());
        break;
      case InventoryTypes.prime:
        store.dispatch(GetPrimeProductsAction());
        break;
      case InventoryTypes.underCheckAvailability:
        store.dispatch(GetUnderCheckAvailabilityAction());
        break;
    }
  } else if (action is GetNotificationProductsAction) {
    Either either = await store.state.inventoryState.inventoryUseCase.getNotificationProductsUseCase(
        pageNumber: store.state.inventoryState.pageNumber,
        subWarehouseId: store.state.inventoryState.subWarehouseId,
        isActive: store.state.inventoryState.isActive);
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
  } else if (action is GetUnderCheckAvailabilityAction) {
    Either either = await store.state.inventoryState.inventoryUseCase
        .getUnderCheckAvailabilityUseCase(subWarehouseId: store.state.inventoryState.subWarehouseId);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')), (products) {
      List<ProductData> theProducts = products;
      if (store.state.inventoryState.isActive < 2) {
        theProducts.removeWhere((product) => product.isActive != store.state.inventoryState.isActive.toString());
      }
      store.dispatch(SetInventoryProducts(products: theProducts));
      store.dispatch(EndOfProducts());
    });
    store.dispatch(StopLoading());
  } else if (action is TargetInventoryAction) {
    store.dispatch(StartLoading());
    Either either = await store.state.inventoryState.inventoryUseCase.targetInventoryUseCase();
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')),
        (_) => snackBar(context: action.context, message: 'حدث خطأ', success: false));
    store.dispatch(StopLoading());
  } else if (action is KeepingInventoriesRecordAction) {
    store.dispatch(StartLoading());
    Either either = await store.state.inventoryState.inventoryUseCase.keepingInventoriesRecordUseCase();
    either.fold((failure) => snackBar(context: action.context, message: 'حدث خطأ', success: false),
        (_) => snackBar(context: action.context, message: 'تم الجرد بنجاح', success: true));
    store.dispatch(StopLoading());
  }
  next(action);
}
