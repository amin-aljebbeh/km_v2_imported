import 'package:dartz/dartz.dart';
import 'package:kammun_app/features/coupons/domain/entities/get_coupons_response_entity.dart';

import '../../../../core/core_importer.dart';
import '../repositories/coupon_repository.dart';

class GetCouponsUseCase {
  final CouponsRepository couponRepository;

  GetCouponsUseCase({this.couponRepository});

  Future<Either<Failure, GetCouponsResponseEntity>> call(
      {int isGeneral, int isForDelivery, String code, int page}) async {
    return await couponRepository.getCoupons(
        code: code, isForDelivery: isForDelivery, isGeneral: isGeneral, page: page);
  }
}
