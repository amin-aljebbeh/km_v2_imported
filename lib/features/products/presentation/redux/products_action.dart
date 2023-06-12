import 'package:dartz/dartz.dart';
import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

import '../../domain/entities/category_products_entity.dart';

abstract class ProductsAction {
  handle({@required Store<AppState> store});
}

class GetProductsAction extends ProductsAction {
  @override
  handle({Store<AppState> store}) {
    switch (store.state.productsState.productsViewType) {
      case ProductsViewTypes.search:
        store.dispatch(SearchProductsAction());
        break;
      case ProductsViewTypes.category:
        store.dispatch(GetCategoryProductsAction());
        break;
      case ProductsViewTypes.barcode:
        store.dispatch(GetBarcodeProductsAction());
        break;
    }
  }
}

class GetCategoryProductsAction extends ProductsAction {
  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.productsState.productsUSeCases.getCategoryProductsUseCase(
        categoryId: store.state.productsState.categoryId, pageNumber: store.state.productsState.productsPage);
    either.fold(
        (failure) => store
            .dispatch(CatchError(errorMessage: 'حدث خطأ أثناء محاولة جلب البيانات \n يرجى التحقق من إتصالك بالأنترنت')),
        (response) {
      CategoryProductsEntity categoryProducts = response;
      List<ProductEntity> products = [];
      products.addAll(store.state.productsState.products);
      products.addAll(categoryProducts.page.products);
      store.dispatch(SetProducts(products: products));
      if (categoryProducts.page.lastPage == store.state.productsState.productsPage) {
        store.dispatch(EndOfProducts(endOfProducts: true));
      }
    });
    store.dispatch(StopLoading());
  }
}

class SearchProductsAction extends ProductsAction {
  @override
  handle({Store<AppState> store}) async {
    if (badWords.contains(store.state.productsState.searchString)) {
      store.dispatch(BadWordMatched(matched: true));
    } else {
      store.dispatch(StartLoading());
      Either either = await store.state.productsState.productsUSeCases.searchProductsUseCase(
          query: store.state.productsState.searchString, pageNumber: store.state.productsState.productsPage);
      either.fold(
          (failure) => store.dispatch(
              CatchError(errorMessage: 'حدث خطأ أثناء محاولة جلب البيانات \n يرجى التحقق من إتصالك بالأنترنت')),
          (response) {
        CategoryProductsEntity categoryProducts = response;
        List<ProductEntity> products = [];
        products.addAll(store.state.productsState.products);
        products.addAll(categoryProducts.page.products);
        store.dispatch(SetProducts(products: products));
        if (categoryProducts.page.lastPage == store.state.productsState.productsPage) {
          store.dispatch(EndOfProducts(endOfProducts: true));
        }
      });
      store.dispatch(StopLoading());
    }
  }
}

class GetBarcodeProductsAction extends ProductsAction {
  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.productsState.productsUSeCases
        .getBarcodeProductsUseCase(barcode: store.state.barcodeState.barcodeString);
    either.fold(
        (failure) => store
            .dispatch(CatchError(errorMessage: 'حدث خطأ أثناء محاولة جلب البيانات \n يرجى التحقق من إتصالك بالأنترنت')),
        (response) {
      List<ProductEntity> barcodeProducts = response;
      store.dispatch(SetProducts(products: barcodeProducts));
      store.dispatch(EndOfProducts(endOfProducts: true));
    });
    store.dispatch(StopLoading());
  }
}

class SetProducts {
  final List<ProductEntity> products;

  SetProducts({this.products});
}

class SetProductsPage {
  final int page;

  SetProductsPage({this.page});
}

class EndOfProducts {
  final bool endOfProducts;

  EndOfProducts({this.endOfProducts});
}

class BadWordMatched {
  final bool matched;

  BadWordMatched({this.matched});
}

class SetProductsViewTypes {
  final ProductsViewTypes productsViewTypes;

  SetProductsViewTypes({this.productsViewTypes});
}

class SetCategoryId {
  final int categoryId;

  SetCategoryId({this.categoryId});
}

class SetSearchString {
  final String searchString;

  SetSearchString({this.searchString});
}

class InitProducts extends ProductsAction {
  @override
  handle({Store<AppState> store}) {
    store.dispatch(SetProducts(products: []));
    store.dispatch(EndOfProducts(endOfProducts: false));
    store.dispatch(SetProductsPage(page: 1));
    store.dispatch(SetCategoryId(categoryId: -1));
    store.dispatch(BadWordMatched(matched: false));
    store.dispatch(SetSearchString(searchString: 'null'));
    if (store.state.loadingState.loading.isNotEmpty) store.dispatch(StopLoading());
  }
}
