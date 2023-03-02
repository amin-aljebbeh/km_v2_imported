import '../../../../core/core_importer.dart';
import '../../domain/entities/coupon_entity.dart';
import 'coupon_action.dart';
import 'coupon_state.dart';

Reducer<CouponState> couponReducer = combineReducers<CouponState>([
  TypedReducer<CouponState, SetCoupons>(setCoupons),
  TypedReducer<CouponState, FirstCouponsPage>(firstCouponsPage),
  TypedReducer<CouponState, NextCouponsPage>(nextCouponsPage),
  TypedReducer<CouponState, EndOfCoupons>(endOfCoupons),
  TypedReducer<CouponState, SetUserCoupons>(setUserCoupons),
]);

CouponState setCoupons(CouponState state, SetCoupons action) {
  List<CouponEntity> coupons = [];
  coupons.addAll(state.coupons);
  coupons.addAll(action.coupons);
  return state.copyWith(coupons: coupons);
}

CouponState setUserCoupons(CouponState state, SetUserCoupons action) {
  return state.copyWith(userCoupons: action.coupons);
}

CouponState firstCouponsPage(CouponState state, FirstCouponsPage action) {
  return state.copyWith(pageNumber: 1, coupons: [], hasNext: true);
}

CouponState nextCouponsPage(CouponState state, NextCouponsPage action) {
  return state.copyWith(pageNumber: state.pageNumber + 1);
}

CouponState endOfCoupons(CouponState state, EndOfCoupons action) {
  return state.copyWith(hasNext: false);
}
