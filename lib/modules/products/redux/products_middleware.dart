import 'package:kammun_app/modules/home_page/services/home_page_service.dart';
import 'package:kammun_app/modules/products/service/products_services.dart';
import '../../../core/core_importer.dart';
import 'products_action.dart';

Future<void> productsMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is GetProducts) {
    store.dispatch(StartLoading());
    store.dispatch(NoError());
    switch (action.productsViewTypes) {
      case ProductsViewTypes.search:
        store.dispatch(SearchProduct(query: action.query));
        break;
      case ProductsViewTypes.category:
        store.dispatch(GetCategory(categoryId: action.query));
        break;
      case ProductsViewTypes.barcode:
        store.dispatch(GetBarcodeProducts(code: action.query));
        break;
      case ProductsViewTypes.favorite:
        store.dispatch(GetFavorites());
        break;
      case ProductsViewTypes.alert:
        store.dispatch(GetAlertProduct());
        break;
      case ProductsViewTypes.featuredProducts:
        store.dispatch(GetFeaturedProducts(url: action.query));
        break;
    }
  } else if (action is GetCategory) {
    List<ProductData> products = await ProductsServices.getCategory(
        pageNumber: store.state.productsState.pageNumber, categoryId: action.categoryId);
    store.dispatch(HandleResponse(products: products));
  } else if (action is SearchProduct) {
    if (badWord.contains(action.query)) {
      store.dispatch(StopLoading());
    } else {
      List<ProductData> products =
          await ProductsServices.searchProduct(pageNumber: store.state.productsState.pageNumber, query: action.query);
      store.dispatch(HandleResponse(products: products));
    }
  } else if (action is GetFavorites) {
    store.dispatch(NoError());
    List<ProductData> products =
        await ProductsServices.getUserFavorites(pageNumber: store.state.productsState.pageNumber);
    store.dispatch(HandleResponse(products: products));
  } else if (action is GetBarcodeProducts) {
    List<ProductData> products = await ProductsServices.getBarcodeProducts(code: action.code);
    store.dispatch(HandleResponse(products: products));
  } else if (action is HandleResponse) {
    if (action.products == null) {
      store.dispatch(CatchError(
          errorMessage: 'حدث خطأ أثناء محاولة جلب المنتجات \n يرجى التحقق من إتصالك بالأنترنت والمحاولة مجدداً'));
    } else if (action.products.isEmpty) {
      store.dispatch(NoError());
      if (store.state.productsState.pageNumber > 1) {
        store.dispatch(EndOfProducts());
      } else {
        store.dispatch(EmptyList());
      }
    } else {
      store.dispatch(NoError());
      if (store.state.productsState.productsType == ProductsViewTypes.barcode) {
        store.dispatch(FirstProductPage());
      }
      store.dispatch(ProductsFetchedSuccessfully(products: action.products));
      if (store.state.productsState.productsType == ProductsViewTypes.favorite) {
        List<int> favorites = action.products.map((product) => product.id).toList();
        store.dispatch(SaveFavorites(favorites: favorites));
      }
    }
    store.dispatch(StopLoading());
  } else if (action is GetAlertProduct) {
    List<ProductData> products =
        await ProductsServices.getMyAlertProducts(pageNumber: store.state.productsState.pageNumber);
    store.dispatch(HandleResponse(products: products));
  } else if (action is GetFeaturedProducts) {
    List<ProductData> featuredProducts =
        (await HomePageService.getSpecialProducts(url: action.url, pageNumber: store.state.productsState.pageNumber))
            .data
            .data;
    if (featuredProducts != null) {
      store.dispatch(HandleResponse(products: featuredProducts));
    } else {
      store.dispatch(HandleResponse(products: []));
      store.dispatch(CatchError(errorMessage: 'could not get featured products'));
    }
  }
  next(action);
}
