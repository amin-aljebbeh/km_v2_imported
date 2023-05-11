import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../../domain/entities/coupon_entity.dart';
import '../../domain/entities/get_coupons_response_entity.dart';

abstract class CouponsAction {
  handle({@required Store<AppState> store});
}

class GetCouponsAction implements CouponsAction {
  final int isGeneral;
  final int isForDelivery;
  final String code;

  GetCouponsAction({this.isGeneral, this.isForDelivery, this.code});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.couponState.couponsUseCase.getCouponsUseCase(
        isGeneral: 0, code: code, isForDelivery: isForDelivery, page: store.state.couponState.pageNumber);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')), (coupons) {
      var result = coupons as GetCouponsResponseEntity;
      if (result.data.currentPage == result.data.lastPage) store.dispatch(EndOfCoupons());
      store.dispatch(SetCoupons(coupons: result.data.coupons));
    });
    store.dispatch(StopLoading());
  }
}

class GetUserCouponsAction implements CouponsAction {
  final int userId;

  GetUserCouponsAction({this.userId});

  @override
  handle({Store<AppState> store}) async {
    store.dispatch(StartLoading());
    Either either = await store.state.couponState.couponsUseCase.getUSerCouponsUseCase(userId: userId);
    either.fold((failure) => store.dispatch(CatchError(errorMessage: 'حدث خطأ')),
        (coupons) => store.dispatch(SetUserCoupons(coupons: coupons)));
    store.dispatch(StopLoading());
  }
}

class SetCoupons {
  final List<CouponEntity> coupons;

  SetCoupons({this.coupons});
}

class SetUserCoupons {
  final List<CouponEntity> coupons;

  SetUserCoupons({this.coupons});
}

class FirstCouponsPage {}

class NextCouponsPage {}

class EndOfCoupons {}
