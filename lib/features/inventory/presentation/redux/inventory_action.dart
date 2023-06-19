import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

import '../../../../core/core_importer.dart';
import '../../../products_filter/domain/entities/products_pagination_entity.dart';
import '../../domain/entities/prices_changes_entity.dart';
import '../pages/inventory_page.dart';

abstract class InventoryAction {
  handle({@required Store<AppState> store});
}

class InitialInventory extends InventoryAction {
  InitialInventory({this.context});

  final BuildContext context;

  @override
  handle({Store<AppState> store}) {
    store.dispatch(NoError());
    store.dispatch(ClearInventory());
    if ((((store.state.inventoryState.inventoryType == InventoryTypes.notAdded &&
                store.state.inventoryState.notAddedProducts.isEmpty) ||
            (store.state.inventoryState.inventoryType == InventoryTypes.all &&
                store.state.inventoryState.allProducts.isEmpty))) ||
        ![InventoryTypes.notAdded, InventoryTypes.all].contains(store.state.inventoryState.inventoryType)) {
      store.dispatch(StartLoading());
      store.dispatch(GetInventory(context: context));
    }
  }
}

class GoToInventoryPage extends InventoryAction {
  final InventoryTypes inventoryType;
  final BuildContext context;
  final int subWarehouseId;

  GoToInventoryPage({this.subWarehouseId = -1, this.inventoryType, this.context});

  @override
  handle({Store<AppState> store}) {
    store.dispatch(SetSearchFilter(searchFilter: ''));
    store.dispatch(SetSubWarehouseFilter(filter: 0));
    store.dispatch(SetIsActive(isActive: 0));
    store.dispatch(NoError());
    store.dispatch(SetInventoryType(inventoryType: inventoryType));
    store.dispatch(SetInventorySubWarehouseId(subWarehouseId: subWarehouseId));
    Navigator.push(context, MaterialPageRoute(builder: (_) => const InventoryPage()));
  }
}

class GetInventory implements InventoryAction {
  final BuildContext context;

  GetInventory({this.context});

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
      case InventoryTypes.all:
        store.dispatch(GetAllProductsAction());
        break;
      case InventoryTypes.notAdded:
        store.dispatch(GetNotAddedProductsAction());
        break;
      case InventoryTypes.added:
        store.dispatch(GetAddedProductsAction());
        break;
      case InventoryTypes.barcode:
        switch (store.state.barcodeState.barcodeRequestType) {
          case BarcodeRequestType.addBarcode:
          case BarcodeRequestType.addProduct:
            store.dispatch(CheckProductsBarcodeAction(context: context));
            break;

          case BarcodeRequestType.attachProduct:
            store.dispatch(SearchProductByBarcodeAction(context: context));
            break;
          case BarcodeRequestType.search:
            break;
        }
        break;
      case InventoryTypes.prices:
        store.dispatch(GetPriceChangesAction());
        break;
      case InventoryTypes.subWarehouse:
        store.dispatch(GetSubWarehouseProductsAction());
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
      ProductsPaginationEntity filteredProductsModel = products;
      store.dispatch(SetInventoryProducts(products: filteredProductsModel.page.products));
      if (filteredProductsModel.page.nextPageUrl == null) store.dispatch(EndOfInventory());
    });
    store.dispatch(StopLoading());
  }
}

class GetPriceChangesAction implements InventoryAction {
  @override
  handle({Store<AppState> store}) async {
    Either either = await store.state.inventoryState.inventoryUseCase.getPriceChangesUseCase();
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')), (products) {
      PricesChangesEntity prices = products;
      store.dispatch(SetInventoryProducts(products: prices.products));
      store.dispatch(EndOfInventory());
    });
    store.dispatch(StopLoading());
  }
}

class CheckProductsBarcodeAction implements InventoryAction {
  final BuildContext context;

  CheckProductsBarcodeAction({this.context});

  @override
  handle({Store<AppState> store}) async {
    Either either = await store.state.inventoryState.inventoryUseCase
        .checkProductsBarcodeUseCase(barcode: store.state.barcodeState.barcodeString);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')), (products) {
      if (products.isEmpty) {
        Navigator.pop(context);
        store.state.barcodeState.onIgnore(store.state.barcodeState.barcodeString);
      } else {
        store.dispatch(SetInventoryProducts(products: products));
        store.dispatch(EndOfInventory());
      }
    });
    store.dispatch(StopLoading());
  }
}

class SearchProductByBarcodeAction implements InventoryAction {
  final BuildContext context;

  SearchProductByBarcodeAction({this.context});

  @override
  handle({Store<AppState> store}) async {
    Either either = await store.state.inventoryState.inventoryUseCase
        .searchProductByBarcodeUseCase(barcode: store.state.barcodeState.barcodeString);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')), (products) {
      if (products.isEmpty) {
        Navigator.pop(context);
        store.state.barcodeState.onIgnore(store.state.barcodeState.barcodeString);
      } else {
        store.dispatch(SetInventoryProducts(products: products));
        store.dispatch(EndOfInventory());
      }
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
      ProductsPageEntity filteredProductsModel = products;
      store.dispatch(SetInventoryProducts(products: filteredProductsModel.products));
      if (filteredProductsModel.nextPageUrl == null) store.dispatch(EndOfInventory());
    });
    store.dispatch(StopLoading());
  }
}

class GetAllProductsAction implements InventoryAction {
  @override
  handle({Store<AppState> store}) async {
    Either either = await store.state.inventoryState.inventoryUseCase.getAllProductsUseCase();
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')), (products) {
      store.dispatch(SetIAllProducts(products: products));
      store.dispatch(EndOfInventory());
    });
    store.dispatch(StopLoading());
  }
}

class GetNotAddedProductsAction implements InventoryAction {
  @override
  handle({Store<AppState> store}) async {
    Either either = await store.state.inventoryState.inventoryUseCase.getNotAddedProductsUseCase();
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')), (products) {
      products.sort((a, b) {
        if (a.id > b.id) {
          return -1;
        } else if (a.id < b.id) {
          return 1;
        }
        return 0;
      });
      store.dispatch(EndOfInventory());
      store.dispatch(SetNotAddedProducts(products: products));
    });
    store.dispatch(StopLoading());
  }
}

class GetAddedProductsAction implements InventoryAction {
  @override
  handle({Store<AppState> store}) async {
    Either either = await store.state.inventoryState.inventoryUseCase.getAddedProductsUseCase();
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')), (products) {
      store.dispatch(EndOfInventory());
      store.dispatch(SetInventoryProducts(products: products));
    });
    store.dispatch(StopLoading());
  }
}

class GetSubWarehouseProductsAction implements InventoryAction {
  @override
  handle({Store<AppState> store}) async {
    Either either = await store.state.inventoryState.inventoryUseCase
        .getSubWarehouseProductsUseCase(subWarehouseId: store.state.inventoryState.subWarehouseId);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')), (products) {
      products.sort((a, b) {
        if (int.parse(a.isActive) == 0) {
          return -1;
        } else {
          return 1;
        }
      });
      store.dispatch(EndOfInventory());
      store.dispatch(SetInventoryProducts(products: products));
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
      List<ProductEntity> theProducts = products;
      if (store.state.inventoryState.isActive < 2) {
        theProducts.removeWhere((product) => product.isActive != store.state.inventoryState.isActive.toString());
      }
      theProducts.sort((a, b) {
        if (a.categories.isNotEmpty && b.categories.isNotEmpty) {
          if (a.categories[0].id > b.categories[0].id) {
            return 1;
          } else {
            return -1;
          }
        } else {
          return -1;
        }
      });
      store.dispatch(SetInventoryProducts(products: theProducts));
      store.dispatch(EndOfInventory());
    });
    store.dispatch(StopLoading());
  }
}

class SetInventoryProducts {
  final List<ProductEntity> products;

  SetInventoryProducts({this.products});
}

class SetIAllProducts {
  final List<ProductEntity> products;

  SetIAllProducts({this.products});
}

class SetNotAddedProducts {
  final List<ProductEntity> products;

  SetNotAddedProducts({this.products});
}

class ClearInventory {}

class SetSearchFilter {
  final String searchFilter;

  SetSearchFilter({this.searchFilter});
}

class ChangeSubWarehouseFilter {
  final BuildContext context;

  ChangeSubWarehouseFilter({this.context});
}

class SetSubWarehouseFilter {
  final int filter;

  SetSubWarehouseFilter({this.filter});
}

class EndOfInventory {}

class NextPage {}

class SetInventoryType {
  final InventoryTypes inventoryType;

  SetInventoryType({this.inventoryType});
}

class SetInventorySubWarehouseId {
  final int subWarehouseId;

  SetInventorySubWarehouseId({this.subWarehouseId});
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
