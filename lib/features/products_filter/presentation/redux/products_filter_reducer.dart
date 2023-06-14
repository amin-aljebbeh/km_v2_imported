import '../../../../core/core_importer.dart';
import 'products_filter_action.dart';
import 'products_filter_state.dart';

Reducer<ProductsFilterState> productsFilterReducer = combineReducers<ProductsFilterState>([
  TypedReducer<ProductsFilterState, SetFilteredProducts>(setFilteredProducts),
  TypedReducer<ProductsFilterState, SetFilteredProductsPage>(setFilteredProductsPage),
  TypedReducer<ProductsFilterState, EndOfFilteredProducts>(endOfFilteredProducts),
  TypedReducer<ProductsFilterState, SetFilteredProductsViewTypes>(setFilteredProductsViewTypes),
  TypedReducer<ProductsFilterState, SetProductsFilterSearchString>(setProductsFilterSearchString),
]);

ProductsFilterState setFilteredProducts(ProductsFilterState state, SetFilteredProducts action) {
  return state.copyWith(filteredProducts: action.products);
}

ProductsFilterState setFilteredProductsPage(ProductsFilterState state, SetFilteredProductsPage action) {
  return state.copyWith(filteredProductsPage: action.page);
}

ProductsFilterState endOfFilteredProducts(ProductsFilterState state, EndOfFilteredProducts action) {
  return state.copyWith(hasNextFilteredProducts: action.endOfProducts);
}

ProductsFilterState setFilteredProductsViewTypes(ProductsFilterState state, SetFilteredProductsViewTypes action) {
  return state.copyWith(filteredProductsTypes: action.type);
}

ProductsFilterState setProductsFilterSearchString(ProductsFilterState state, SetProductsFilterSearchString action) {
  return state.copyWith(productsFilterSearchString: action.searchString);
}
