import '../../../../core/core_importer.dart';
import '../../domain/entities/coupon_entity.dart';
import '../../domain/use_cases/coupon_use_cases.dart';

@immutable
class CouponState extends Equatable {
  final CouponsUseCases couponsUseCase;
  final List<CouponEntity> coupons;
  final int pageNumber;
  final bool hasNext;
  const CouponState({this.couponsUseCase, this.coupons, this.pageNumber, this.hasNext});

  factory CouponState.initial() {
    return CouponState(couponsUseCase: sl<CouponsUseCases>(), coupons: const [], pageNumber: 1, hasNext: true);
  }

  CouponState copyWith({List<CouponEntity> coupons, int pageNumber, bool hasNext}) {
    return CouponState(
        couponsUseCase: couponsUseCase,
        coupons: coupons ?? this.coupons,
        pageNumber: pageNumber ?? this.pageNumber,
        hasNext: hasNext ?? this.hasNext);
  }

  @override
  List<Object> get props => [couponsUseCase, coupons, pageNumber, hasNext];
}
