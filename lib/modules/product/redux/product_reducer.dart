import '../../../core/core_importer.dart';
import 'product_action.dart';
import 'product_state.dart';

Reducer<ProductState> productReducer = combineReducers<ProductState>([
  TypedReducer<ProductState, UserVisitProduct>(userVisitProduct),
]);

ProductState userVisitProduct(ProductState state, UserVisitProduct action) {
  return state.copyWith(selectedImage: 0, product: action.product);
}
