import 'package:kammun_app/features/products/presentation/redux/products_state.dart';

import '../../../../core/core_importer.dart';
import 'products_action.dart';

Reducer<ProductsState> productsReducer = combineReducers<ProductsState>([
  TypedReducer<ProductsState, SetProducts>(setProducts),
  TypedReducer<ProductsState, SetProductsPage>(setProductsPage),
  TypedReducer<ProductsState, EndOfProducts>(endOfProducts),
  TypedReducer<ProductsState, BadWordMatched>(badWordMatched),
  TypedReducer<ProductsState, SetProductsViewTypes>(setProductsViewTypes),
  TypedReducer<ProductsState, SetCategoryId>(setCategoryId),
  TypedReducer<ProductsState, SetSearchString>(setSearchString),
]);

ProductsState setProducts(ProductsState state, SetProducts action) {
  return state.copyWith(products: action.products);
}

ProductsState setProductsPage(ProductsState state, SetProductsPage action) {
  return state.copyWith(productsPage: action.page);
}

ProductsState endOfProducts(ProductsState state, EndOfProducts action) {
  return state.copyWith(hasNextProducts: !action.endOfProducts);
}

ProductsState badWordMatched(ProductsState state, BadWordMatched action) {
  return state.copyWith(badWordMatched: action.matched);
}

ProductsState setProductsViewTypes(ProductsState state, SetProductsViewTypes action) {
  return state.copyWith(productsViewType: action.productsViewTypes);
}

ProductsState setCategoryId(ProductsState state, SetCategoryId action) {
  return state.copyWith(categoryId: action.categoryId);
}

ProductsState setSearchString(ProductsState state, SetSearchString action) {
  return state.copyWith(searchString: action.searchString);
}
