import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../entities/coupon_entity.dart';
import '../repositories/coupon_repository.dart';

class GetCouponsUseCase {
  final CouponsRepository couponRepository;

  GetCouponsUseCase({this.couponRepository});

  Future<Either<Failure, List<CouponEntity>>> call({int isGeneral, int isForDelivery, String code}) async {
    return await couponRepository.getCoupons(code: code, isForDelivery: isForDelivery, isGeneral: isGeneral);
  }
}
