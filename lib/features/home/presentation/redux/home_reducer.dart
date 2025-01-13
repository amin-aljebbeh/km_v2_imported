import '../../../../core/core_importer.dart';
import 'home_action.dart';
import 'home_state.dart';

Reducer<HomeState> homeReducer = combineReducers<HomeState>([
  TypedReducer<HomeState, SetSpecialProducts>(setSpecialProducts),
  TypedReducer<HomeState, SetPageIndex>(setPageIndex),
  TypedReducer<HomeState, SetHomeLoadingAction>(setHomeLoadingAction),
  TypedReducer<HomeState, SetBannerAction>(setBannerAction),
]);

HomeState setPageIndex(HomeState state, SetPageIndex action) => state.copyWith(pageIndex: action.index);

HomeState setSpecialProducts(HomeState state, SetSpecialProducts action) {
  return state.copyWith(specialProducts: action.specialProducts);
}

HomeState setBannerAction(HomeState state, SetBannerAction action) {
  return state.copyWith(banners: action.banners);
}

HomeState setHomeLoadingAction(HomeState state, SetHomeLoadingAction action) {
  return state.copyWith(loading: action.loading);
}
