import 'package:dartz/dartz.dart';

import '../../../../core/core_importer.dart';
import '../entities/coupon_entity.dart';
import '../repositories/coupon_repository.dart';

class GetUserCouponsUseCase {
  final CouponsRepository couponRepository;

  GetUserCouponsUseCase({this.couponRepository});

  Future<Either<Failure, List<CouponEntity>>> call({int userId}) async {
    return await couponRepository.getUserCoupons(userId: userId);
  }
}
