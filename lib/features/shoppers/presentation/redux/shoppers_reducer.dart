import '../../../../core/core_importer.dart';
import '../../domain/entities/shopper_entity.dart';
import 'shoppers_action.dart';
import 'shoppers_state.dart';

Reducer<ShoppersState> shoppersReducer = combineReducers<ShoppersState>([
  TypedReducer<ShoppersState, SetShoppers>(setShoppers),
  TypedReducer<ShoppersState, ShopperChanged>(shopperChanged),
]);

ShoppersState setShoppers(ShoppersState state, SetShoppers action) => state.copyWith(shoppers: action.shoppers);

ShoppersState shopperChanged(ShoppersState state, ShopperChanged action) {
  List<ShopperEntity> shoppers = [];
  shoppers.addAll(state.shoppers);
  int index = shoppers.indexWhere((shopper) => shopper.id == action.shopper.id);
  shoppers[index] = action.shopper;
  return state.copyWith(shoppers: shoppers);
}
