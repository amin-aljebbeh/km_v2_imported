import '../../../../core/core_importer.dart';
import 'coupon_action.dart';
import 'coupon_state.dart';

Reducer<CouponState> couponReducer = combineReducers<CouponState>([TypedReducer<CouponState, SetCoupons>(setCoupons)]);

CouponState setCoupons(CouponState state, SetCoupons action) {
  return state.copyWith(coupons: action.coupons);
}
