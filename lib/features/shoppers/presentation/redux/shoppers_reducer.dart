import '../../../../core/core_importer.dart';
import '../../domain/entities/shopper_entity.dart';
import 'shoppers_action.dart';
import 'shoppers_state.dart';

Reducer<ShoppersState> shoppersReducer = combineReducers<ShoppersState>([
  TypedReducer<ShoppersState, SetShoppers>(setShoppers),
  TypedReducer<ShoppersState, ShopperChanged>(shopperChanged),
  TypedReducer<ShoppersState, SetLevels>(setLevels),
  TypedReducer<ShoppersState, SetShopper>(setShopper),
]);

ShoppersState setShoppers(ShoppersState state, SetShoppers action) => state.copyWith(shoppers: action.shoppers);

ShoppersState setLevels(ShoppersState state, SetLevels action) => state.copyWith(levels: action.levels);

ShoppersState setShopper(ShoppersState state, SetShopper action) => state.copyWith(shopper: action.shopper);

ShoppersState shopperChanged(ShoppersState state, ShopperChanged action) {
  List<ShopperEntity> shoppers = [];
  shoppers.addAll(state.shoppers);
  int index = shoppers.indexWhere((shopper) => shopper.id == action.shopper.id);
  shoppers[index] = action.shopper;
  return state.copyWith(shoppers: shoppers);
}
