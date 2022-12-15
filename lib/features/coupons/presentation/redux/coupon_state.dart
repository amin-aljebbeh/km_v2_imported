import '../../../../core/core_importer.dart';
import '../../domain/entities/coupon_entity.dart';
import '../../domain/use_cases/coupon_use_cases.dart';

@immutable
class CouponState extends Equatable {
  final CouponsUseCases couponsUseCase;
  final List<CouponEntity> coupons;
  const CouponState({this.couponsUseCase, this.coupons});

  factory CouponState.initial() {
    return CouponState(couponsUseCase: sl<CouponsUseCases>(), coupons: const []);
  }

  CouponState copyWith({List<CouponEntity> coupons}) {
    return CouponState(couponsUseCase: couponsUseCase, coupons: coupons ?? this.coupons);
  }

  @override
  List<Object> get props => [couponsUseCase, coupons];
}
