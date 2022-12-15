import '../../domain/entities/coupon_entity.dart';

class GetCouponsAction {
  final int isGeneral;
  final int isForDelivery;
  final String code;

  GetCouponsAction({this.isGeneral, this.isForDelivery, this.code});
}

class SetCoupons {
  final List<CouponEntity> coupons;

  SetCoupons({this.coupons});
}

class FirstCouponsPage {}

class NextCouponsPage {}

class EndOfCoupons {}
