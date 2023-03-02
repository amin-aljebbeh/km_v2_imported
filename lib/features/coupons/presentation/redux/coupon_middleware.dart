import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/get_coupons_response_entity.dart';
import 'coupon_action.dart';

Future<void> couponMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is GetCouponsAction) {
    store.dispatch(StartLoading());
    Either either = await store.state.couponState.couponsUseCase.getCouponsUseCase(
        isGeneral: 0, code: action.code, isForDelivery: action.isForDelivery, page: store.state.couponState.pageNumber);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')), (coupons) {
      var result = coupons as GetCouponsResponseEntity;
      if (result.data.currentPage == result.data.lastPage) store.dispatch(EndOfCoupons());
      store.dispatch(SetCoupons(coupons: result.data.coupons));
    });
    store.dispatch(StopLoading());
  } else if (action is GetUserCouponsAction) {
    store.dispatch(StartLoading());
    Either either = await store.state.couponState.couponsUseCase.getUSerCouponsUseCase(userId: action.userId);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')),
        (coupons) => store.dispatch(SetUserCoupons(coupons: coupons)));
    store.dispatch(StopLoading());
  }
  next(action);
}
