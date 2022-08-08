import '../../../core/core_importer.dart';
import 'home_page_action.dart';
import 'home_page_state.dart';

Reducer<HomePageState> homePageReducer = combineReducers<HomePageState>([
  TypedReducer<HomePageState, SetSpecialProducts>(setSpecialProducts),
  TypedReducer<HomePageState, StartStoreLoading>(startStoreLoading),
  TypedReducer<HomePageState, StopStoreLoading>(stopStoreLoading),
]);

HomePageState setSpecialProducts(HomePageState state, SetSpecialProducts action) {
  return state.copyWith(specialProducts: action.specialProducts);
}

HomePageState startStoreLoading(HomePageState state, StartStoreLoading action) {
  return state.copyWith(loading: true);
}

HomePageState stopStoreLoading(HomePageState state, StopStoreLoading action) {
  return state.copyWith(loading: false);
}
