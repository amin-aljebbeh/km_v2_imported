import '../../domain/entities/coupon_entity.dart';

class GetCouponsAction {
  final int isGeneral;
  final int isForDelivery;
  final String code;

  GetCouponsAction({this.isGeneral, this.isForDelivery, this.code});
}

class GetUserCouponsAction {
  final int userId;

  GetUserCouponsAction({this.userId});
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
