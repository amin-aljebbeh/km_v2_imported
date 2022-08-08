import 'package:kammun_app/core/core_importer.dart';

import 'products_action.dart';
import 'products_state.dart';

Reducer<ProductsState> productsReducer = combineReducers<ProductsState>([
  TypedReducer<ProductsState, GetCategory>(getCategory),
  TypedReducer<ProductsState, SearchProduct>(searchProduct),
  TypedReducer<ProductsState, GetFavorites>(getFavorites),
  TypedReducer<ProductsState, GetBarcodeProducts>(getBarcodeProducts),
  TypedReducer<ProductsState, ProductsFetchedSuccessfully>(productsFetchedSuccessfully),
  TypedReducer<ProductsState, SetAlertProducts>(setAlertProducts),
  TypedReducer<ProductsState, EndOfProducts>(endOfProducts),
  TypedReducer<ProductsState, EmptyList>(emptyList),
  TypedReducer<ProductsState, NextProductsPage>(nextPage),
  TypedReducer<ProductsState, GetProducts>(getProducts),
  TypedReducer<ProductsState, FirstProductPage>(firstPage),
  TypedReducer<ProductsState, AddProductToFavoritesList>(addProductToFavoritesList),
  TypedReducer<ProductsState, RemoveProductFromFavoritesList>(removeProductFromFavoritesList),
  TypedReducer<ProductsState, SaveFavorites>(saveFavorites),
  TypedReducer<ProductsState, ProductAddedToFavoritesSuccessfully>(productAddedToFavoritesSuccessfully),
  TypedReducer<ProductsState, ProductRemovedFromFavoritesSuccessfully>(productRemovedFromFavorites),
  TypedReducer<ProductsState, NotificationRequestSentSuccessfully>(notificationRequestSentSuccessfully),
  TypedReducer<ProductsState, NotificationRequestDeletedSuccessfully>(notificationRequestDeletedSuccessfully),
  TypedReducer<ProductsState, SetType>(setType),
  TypedReducer<ProductsState, GetAlertProduct>(getAlertProduct),
  TypedReducer<ProductsState, GetAlertProduct>(getAlertProduct),
  TypedReducer<ProductsState, GetAlertProduct>(getAlertProduct),
]);

ProductsState getCategory(ProductsState state, GetCategory action) {
  return state.copyWith(productsType: ProductsViewTypes.category);
}

ProductsState searchProduct(ProductsState state, SearchProduct action) {
  return state.copyWith(productsType: ProductsViewTypes.search);
}

ProductsState getFavorites(ProductsState state, GetFavorites action) {
  return state.copyWith(productsType: ProductsViewTypes.favorite);
}

ProductsState getBarcodeProducts(ProductsState state, GetBarcodeProducts action) {
  return state.copyWith(productsType: ProductsViewTypes.barcode);
}

ProductsState getAlertProduct(ProductsState state, GetAlertProduct action) {
  return state.copyWith(productsType: ProductsViewTypes.alert);
}

ProductsState getFeaturedProducts(ProductsState state, GetFeaturedProducts action) {
  return state.copyWith(productsType: ProductsViewTypes.featuredProducts);
}

ProductsState productsFetchedSuccessfully(ProductsState state, ProductsFetchedSuccessfully action) {
  List<ProductData> products = state.products;
  products.addAll(action.products);
  return state.copyWith(products: products);
}

ProductsState setAlertProducts(ProductsState state, SetAlertProducts action) {
  return state.copyWith(products: action.products);
}

ProductsState endOfProducts(ProductsState state, EndOfProducts action) {
  return state.copyWith(hasNext: false);
}

ProductsState emptyList(ProductsState state, EmptyList action) {
  return state.copyWith(hasNext: false, emptyList: true);
}

ProductsState nextPage(ProductsState state, NextProductsPage action) {
  return state.copyWith(pageNumber: state.pageNumber + 1);
}

ProductsState getProducts(ProductsState state, GetProducts action) {
  return state.copyWith(productsType: action.productsViewTypes);
}

ProductsState firstPage(ProductsState state, FirstProductPage action) {
  return state.copyWith(pageNumber: 1, products: [], hasNext: true);
}

ProductsState addProductToFavoritesList(ProductsState state, AddProductToFavoritesList action) {
  List<int> favorites = state.favorites;
  favorites.add(action.productId);
  return state.copyWith(favorites: favorites);
}

ProductsState removeProductFromFavoritesList(ProductsState state, RemoveProductFromFavoritesList action) {
  List<int> favorites = state.favorites;
  favorites.remove(action.productId);
  return state.copyWith(favorites: favorites);
}

ProductsState saveFavorites(ProductsState state, SaveFavorites action) {
  List<int> favorites = [];
  favorites.addAll(state.favorites);
  favorites.addAll(action.favorites);
  return state.copyWith(favorites: favorites);
}

ProductsState productAddedToFavoritesSuccessfully(ProductsState state, ProductAddedToFavoritesSuccessfully action) {
  List<int> favorites = [];
  favorites.addAll(state.favorites);
  favorites.add(action.productId);
  return state.copyWith(favorites: favorites);
}

ProductsState productRemovedFromFavorites(ProductsState state, ProductRemovedFromFavoritesSuccessfully action) {
  List<int> favorites = [];
  favorites.addAll(state.favorites);
  favorites.remove(action.productId);
  return state.copyWith(favorites: favorites);
}

ProductsState notificationRequestSentSuccessfully(ProductsState state, NotificationRequestSentSuccessfully action) {
  List<ProductData> products = [];
  products.addAll(state.products);

  products.firstWhere((product) => product.id == action.productId).productAlert =
      ProductAlert(id: action.alertId, productId: action.productId);
  return state.copyWith(products: products);
}

ProductsState notificationRequestDeletedSuccessfully(
    ProductsState state, NotificationRequestDeletedSuccessfully action) {
  List<ProductData> products = [];
  products.addAll(state.products);

  products.firstWhere((product) => product.id == action.productId).productAlert = null;
  return state.copyWith(products: products);
}

ProductsState setType(ProductsState state, SetType action) {
  return state.copyWith(productsType: action.productsViewTypes);
}
