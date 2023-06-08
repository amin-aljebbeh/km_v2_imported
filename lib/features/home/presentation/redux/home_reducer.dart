import '../../../../core/core_importer.dart';
import 'home_action.dart';
import 'home_state.dart';

Reducer<HomeState> homeReducer = combineReducers<HomeState>([
  TypedReducer<HomeState, SetPageIndex>(setPageIndex),
]);

HomeState setPageIndex(HomeState state, SetPageIndex action) => state.copyWith(pageIndex: action.index);
