import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/coupon_entity.dart';
import 'coupon_action.dart';

Future<void> couponMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is GetCouponsAction) {
    store.dispatch(StartLoading());
    Either either = await store.state.couponState.couponsUseCase
        .getCouponsUseCase(isGeneral: 0, code: action.code, isForDelivery: action.isForDelivery);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')), (coupons) {
      var theCoupons = coupons as List<CouponEntity>;
      store.dispatch(SetCoupons(coupons: theCoupons));
    });
    store.dispatch(StopLoading());
  }
  next(action);
}
