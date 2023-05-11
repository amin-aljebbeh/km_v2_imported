import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../../../inventory/model/inventory_model_importer.dart';

abstract class InventoryAction {
  handle({@required Store<AppState> store});
}

class GetInventory implements InventoryAction {
  @override
  handle({Store<AppState> store}) async {
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
  }
}

class GetNotificationProductsAction implements InventoryAction {
  @override
  handle({Store<AppState> store}) async {
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
  }
}

class GetPrimeProductsAction implements InventoryAction {
  @override
  handle({Store<AppState> store}) async {
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
}

class GetUnderCheckAvailabilityAction implements InventoryAction {
  @override
  handle({Store<AppState> store}) async {
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
  }
}

class SetInventoryProducts {
  final List<ProductData> products;

  SetInventoryProducts({this.products});
}

class ClearInventory {}

class SetSearchFilter {
  final String searchFilter;

  SetSearchFilter({this.searchFilter});
}

class EndOfProducts {}

class NextPage {}

class SetInventoryType {
  final InventoryTypes inventoryType;

  SetInventoryType({this.inventoryType});
}

class SetSubWarehouseId {
  final int subWarehouseId;

  SetSubWarehouseId({this.subWarehouseId});
}

class SetIsActive {
  final int isActive;

  SetIsActive({this.isActive});
}

class TargetInventoryAction implements InventoryAction {
  final BuildContext context;
  TargetInventoryAction({this.context});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.inventoryState.inventoryUseCase.targetInventoryUseCase();
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')),
        (_) => snackBar(context: context, message: 'حدث خطأ', success: false));
    store.dispatch(StopLoading());
  }
}

class KeepingInventoriesRecordAction implements InventoryAction {
  final BuildContext context;
  KeepingInventoriesRecordAction({this.context});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.inventoryState.inventoryUseCase.keepingInventoriesRecordUseCase();
    either.fold((failure) => snackBar(context: context, message: 'حدث خطأ', success: false),
        (_) => snackBar(context: context, message: 'تم الجرد بنجاح', success: true));
    store.dispatch(StopLoading());
  }
}
