import '../../../../core/core_importer.dart';
import 'products_filter_action.dart';
import 'products_filter_state.dart';

Reducer<ProductsFilterState> productsFilterReducer = combineReducers<ProductsFilterState>([
  TypedReducer<ProductsFilterState, SetFilteredProducts>(setFilteredProducts),
  TypedReducer<ProductsFilterState, SetFilteredProductsPage>(setFilteredProductsPage),
  TypedReducer<ProductsFilterState, EndOfFilteredProducts>(endOfFilteredProducts),
  TypedReducer<ProductsFilterState, SetFilteredProductsViewTypes>(setFilteredProductsViewTypes),
  TypedReducer<ProductsFilterState, SetProductsFilterSearchString>(setProductsFilterSearchString),
  TypedReducer<ProductsFilterState, SetBiggerThan>(setBiggerThan),
  TypedReducer<ProductsFilterState, SetFilterValue>(setFilterValue),
  TypedReducer<ProductsFilterState, SetFromDate>(setFromDate),
  TypedReducer<ProductsFilterState, SetToDate>(setToDate),
  TypedReducer<ProductsFilterState, SetTotal>(setTotal),
]);

ProductsFilterState setFilteredProducts(ProductsFilterState state, SetFilteredProducts action) {
  return state.copyWith(filteredProducts: action.products);
}

ProductsFilterState setFilteredProductsPage(ProductsFilterState state, SetFilteredProductsPage action) {
  return state.copyWith(filteredProductsPage: action.page);
}

ProductsFilterState endOfFilteredProducts(ProductsFilterState state, EndOfFilteredProducts action) {
  return state.copyWith(hasNextFilteredProducts: !action.endOfProducts);
}

ProductsFilterState setFilteredProductsViewTypes(ProductsFilterState state, SetFilteredProductsViewTypes action) {
  return state.copyWith(filteredProductsTypes: action.type);
}

ProductsFilterState setProductsFilterSearchString(ProductsFilterState state, SetProductsFilterSearchString action) {
  return state.copyWith(productsFilterSearchString: action.searchString);
}

ProductsFilterState setBiggerThan(ProductsFilterState state, SetBiggerThan action) {
  return state.copyWith(biggerThan: action.biggerThan);
}

ProductsFilterState setFromDate(ProductsFilterState state, SetFromDate action) {
  return state.copyWith(fromDate: action.fromDate);
}

ProductsFilterState setToDate(ProductsFilterState state, SetToDate action) {
  return state.copyWith(toDate: action.toDate);
}

ProductsFilterState setFilterValue(ProductsFilterState state, SetFilterValue action) {
  return state.copyWith(number: action.value);
}

ProductsFilterState setTotal(ProductsFilterState state, SetTotal action) {
  return state.copyWith(total: action.total);
}
